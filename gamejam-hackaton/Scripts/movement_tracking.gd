extends CharacterBody2D

@export var speed_normal: float = 40.0
@export var speed_chase: float = 90.0
@export var change_direction_time: float = 2.0
@export var slow_after_miss_time: float = 1.5
@export var slow_speed: float = 20.0

var player_in_range := false
var player_node: CharacterBody2D = null
var current_direction: String = "front"
var is_dead: bool = false
var can_attack_player: bool = true
var is_slowed: bool = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var proximity_area: Area2D = $Proximity_Area
@onready var footstep_player: AudioStreamPlayer2D = $FootstepPlayer
@onready var death_sound_player: AudioStreamPlayer2D = $DeathSoundPlayer
@onready var groan_player: AudioStreamPlayer2D = $GroanPlayer
@onready var groan_timer: Timer = $GroanTimer

func _ready():
	randomize()
	set_random_direction()
	proximity_area.body_entered.connect(_on_player_entered)
	proximity_area.body_exited.connect(_on_player_exited)
	_start_random_movement()

	# Groan logic
	groan_timer.timeout.connect(_on_groan_timer_timeout)
	_set_random_groan_time()

func _physics_process(delta):
	if is_dead:
		return

	if player_in_range and player_node:
		var to_player = (player_node.global_position - global_position).normalized()
		var chase_speed = slow_speed if is_slowed else speed_chase
		velocity = to_player * chase_speed
		update_direction_toward_player()

		if can_attack_player:
			if is_player_in_attack_area():
				attack_player()
			elif is_player_in_range():
				missed_attack()

	move_and_slide()
	update_animation()

func _start_random_movement():
	var timer := Timer.new()
	timer.wait_time = change_direction_time
	timer.one_shot = false
	timer.timeout.connect(set_random_direction)
	add_child(timer)
	timer.start()

func set_random_direction():
	if not player_in_range:
		var angle = randf() * TAU
		velocity = Vector2.RIGHT.rotated(angle) * speed_normal

func update_animation():
	if velocity.length() == 0 or is_dead:
		if footstep_player.playing:
			footstep_player.stop()
		return

	var dir = velocity.normalized()
	if abs(dir.x) > abs(dir.y):
		current_direction = "left" if dir.x < 0 else "right"
	else:
		current_direction = "back" if dir.y < 0 else "front"

	anim_sprite.play("walk-" + current_direction)

	if not footstep_player.playing:
		footstep_player.play()

func _on_player_entered(body):
	if body.is_in_group("player"):
		player_node = body
		player_in_range = true

func _on_player_exited(body):
	if body == player_node:
		player_in_range = false
		player_node = null

func is_player_in_attack_area() -> bool:
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player") and is_facing_player():
			return true
	return false

func is_player_in_range() -> bool:
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			return true
	return false

func is_facing_player() -> bool:
	var to_player = (player_node.global_position - global_position).normalized()
	var facing_dir = velocity.normalized()
	if facing_dir == Vector2.ZERO:
		facing_dir = to_player
	var dot = facing_dir.dot(to_player)
	return dot > 0.7

func update_direction_toward_player():
	var to_player = (player_node.global_position - global_position).normalized()
	if abs(to_player.x) > abs(to_player.y):
		current_direction = "right" if to_player.x > 0 else "left"
	else:
		current_direction = "front" if to_player.y > 0 else "back"

func attack_player():
	can_attack_player = false
	velocity = Vector2.ZERO

	if footstep_player.playing:
		footstep_player.stop()

	anim_sprite.play("attack-" + current_direction)

	if player_node and player_node.has_method("kill"):
		player_node.kill()

	await anim_sprite.animation_finished
	if player_node and not player_node.is_dead:
		anim_sprite.play("idle-" + current_direction)

	await get_tree().create_timer(1.0).timeout
	can_attack_player = true

func missed_attack():
	can_attack_player = false
	is_slowed = true
	velocity = Vector2.ZERO

	if footstep_player.playing:
		footstep_player.stop()

	anim_sprite.play("attack-" + current_direction)

	await anim_sprite.animation_finished
	anim_sprite.play("idle-" + current_direction)

	await get_tree().create_timer(slow_after_miss_time).timeout
	is_slowed = false
	can_attack_player = true

func die():
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO

	if footstep_player.playing:
		footstep_player.stop()

	death_sound_player.play()

	anim_sprite.play("death-" + current_direction)
	set_physics_process(false)
	proximity_area.monitoring = false
	attack_area.monitoring = false
	groan_timer.stop()

	await anim_sprite.animation_finished
	await get_tree().create_timer(3.0).timeout
	queue_free()

# ----------------------------
# 👇 Groan logic
# ----------------------------

func _on_groan_timer_timeout():
	if is_dead:
		return

	if not groan_player.playing:
		groan_player.play()

	_set_random_groan_time()

func _set_random_groan_time():
	groan_timer.wait_time = randf_range(4.0, 10.0)
	groan_timer.start()
