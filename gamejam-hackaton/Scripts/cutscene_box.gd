extends CanvasLayer

@onready var label := $TextPanel/TextContainer/LineLabel

var lines: Array[String] = []
var current_index := 0
var is_active := false
signal cutscene_finished

func _ready():
	visible = false
	set_process_mode(PROCESS_MODE_ALWAYS)

func start_cutscene(new_lines: Array[String]):
	lines = new_lines
	current_index = 0
	is_active = true
	visible = true
	get_tree().paused = true
	show_line()

func show_line():
	if current_index < lines.size():
		label.text = lines[current_index]
	else:
		end_cutscene()

func _unhandled_input(event):
	if not is_active:
		return
	if event.is_action_pressed("ui_accept"):  # ENTER / SPACE
		current_index += 1
		show_line()

func end_cutscene():
	is_active = false
	visible = false
	get_tree().paused = false
	emit_signal("cutscene_finished")
