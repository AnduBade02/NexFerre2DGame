extends CanvasLayer

@export var main_menu_scene: PackedScene

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	visible = false

	$Panel/VBoxContainer/MenuButton.pressed.connect(go_to_main_menu)

func show_death():
	visible = true
	get_tree().paused = true


func go_to_main_menu():
	Global.uncollect_all()  # ⬅️ Resetare pagini
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://start_menu.tscn")
