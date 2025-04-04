extends CharacterBody2D

@export var speed := 150.0

var direction := Vector2.ZERO
var last_direction := "front"

@onready var anim_sprite := $AnimatedSprite2D

func _physics_process(delta):
	direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()

	_update_animation()

func _update_animation():
	if direction == Vector2.ZERO:
		anim_sprite.play("idle-" + last_direction)
	else:
		var dir_str = ""
		if abs(direction.x) > abs(direction.y):
			dir_str = "right" if direction.x > 0 else "left"
		else:
			dir_str = "front" if direction.y > 0 else "back"
		
		last_direction = dir_str
		anim_sprite.play("walk-" + dir_str)
