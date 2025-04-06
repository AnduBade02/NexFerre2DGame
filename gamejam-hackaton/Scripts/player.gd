extends CharacterBody2D

@export var move_speed: float = 100.0
@export var sprint_multiplier: float = 2.0
@export var attack_cooldown: float = 0.4
@onready var collision_shape := $CollisionShape2D  # adaptează calea dacă e diferit
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var footstep_player: AudioStreamPlayer2D = $FootstepPlayer
@onready var stab_miss_player: AudioStreamPlayer2D = $StabMissPlayer
@onready var death_sound_player: AudioStreamPlayer2D = $DeathSoundPlayer


var direction: Vector2 = Vector2.ZERO
var current_direction: String = "-front"
var is_attacking: bool = false
var is_dead: bool = false
var can_attack: bool = true

func _ready():
	collision_shape.disabled = true  # dezactivăm coliziunea
	await get_tree().create_timer(2.0).timeout
	collision_shape.disabled = false  # o reactivăm după 5 secunde
	anim_sprite.animation_finished.connect(_on_animation_finished)
	anim_sprite.play("idle" + current_direction)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	get_input()
	move_and_slide()

	if is_attacking:
		return

	if direction != Vector2.ZERO:
		update_direction_suffix(direction)
		play_walk_animation()
		if not footstep_player.playing:
			footstep_player.play()
	else:
		play_idle_animation()
		if footstep_player.playing:
			footstep_player.stop()

func get_input() -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		return

	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	var current_speed := move_speed
	if Input.is_action_pressed("sprint"):
		current_speed *= sprint_multiplier

	velocity = direction * current_speed

	if Input.is_action_just_pressed("attack") and can_attack:
		perform_attack()

func perform_attack() -> void:
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	if footstep_player.playing:
		footstep_player.stop()

	anim_sprite.play("stab" + current_direction)

	await get_tree().create_timer(0.1).timeout

	var hit_something := false
	for body in attack_area.get_overlapping_bodies():
		if body and body.is_in_group("zombie") and body.has_method("die"):
			hit_something = true
			body.die()

	if not hit_something:
		stab_miss_player.play()

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_animation_finished() -> void:
	if is_dead:
		return
	if is_attacking:
		is_attacking = false
		anim_sprite.play("idle" + current_direction)

func kill() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO

	if footstep_player.playing:
		footstep_player.stop()

	death_sound_player.play()  # ✅ Redă sunetul de moarte

	anim_sprite.play("death" + current_direction)
	set_physics_process(false)
	await get_tree().create_timer(3.0).timeout
	DeathScreen.show_death()


func play_walk_animation() -> void:
	anim_sprite.play("walk" + current_direction)

func play_idle_animation() -> void:
	anim_sprite.play("idle" + current_direction)

func update_direction_suffix(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		current_direction = "-right" if dir.x > 0 else "-left"
	else:
		current_direction = "-back" if dir.y < 0 else "-front"
