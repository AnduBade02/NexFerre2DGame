extends CanvasLayer

@export var main_menu_scene: PackedScene

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	visible = false

	$Panel/VBoxContainer/ResetButton.pressed.connect(reset_level)
	$Panel/VBoxContainer/MenuButton.pressed.connect(go_to_main_menu)

func show_death():
	visible = true
	get_tree().paused = true

func reset_level():
	visible = false
	get_tree().paused = false
	await get_tree().create_timer(0.01).timeout
	get_tree().reload_current_scene()

func go_to_main_menu():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://start_menu.tscn")
