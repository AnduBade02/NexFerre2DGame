extends CharacterBody2D

@export var speed_normal: float = 40.0
@export var speed_chase: float = 90.0
@export var change_direction_time: float = 2.0

var player_in_range := false
var player_node: CharacterBody2D = null
var current_direction: String = "front"
var is_dead: bool = false

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	randomize()
	set_random_direction()
	$Proximity_Area.body_entered.connect(_on_player_entered)
	$Proximity_Area.body_exited.connect(_on_player_exited)
	_start_random_movement()

func _physics_process(delta):
	if is_dead:
		return

	if player_in_range and player_node:
		velocity = (player_node.global_position - global_position).normalized() * speed_chase
	else:
		# dacă nu are target, continuă să se miște în direcția aleatoare
		pass

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
		return

	var dir = velocity.normalized()

	if abs(dir.x) > abs(dir.y):
		current_direction = "left" if dir.x < 0 else "right"
	else:
		current_direction = "back" if dir.y < 0 else "front"

	anim_sprite.play("walk-" + current_direction)

func _on_player_entered(body):
	if body.name == "player":  # sau body.is_in_group("player")
		player_node = body
		player_in_range = true

func _on_player_exited(body):
	if body == player_node:
		player_in_range = false
		player_node = null

func die():
	if is_dead: return
	is_dead = true
	anim_sprite.play("death-" + current_direction)
	set_physics_process(false)
	$Proximity_Area.monitoring = false
	velocity = Vector2.ZERO
	await anim_sprite.animation_finished
	queue_free()
