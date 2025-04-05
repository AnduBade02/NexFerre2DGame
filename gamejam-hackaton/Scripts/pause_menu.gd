extends CanvasLayer

func _ready():
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	visible = false

	$Panel/VBoxContainer/ResumeButton.pressed.connect(resume_game)
	$Panel/VBoxContainer/ResetButton.pressed.connect(reset_level)
	$Panel/VBoxContainer/MenuButton.pressed.connect(go_to_main_menu)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

func resume_game():
	get_tree().paused = false
	visible = false

func reset_level():
	visible = false
	get_tree().paused = false
	await get_tree().create_timer(0.01).timeout  # așteptăm un frame pentru a nu bloca încărcarea
	get_tree().reload_current_scene()

func go_to_main_menu():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://start_menu.tscn")  # asigură-te că e scris corect
