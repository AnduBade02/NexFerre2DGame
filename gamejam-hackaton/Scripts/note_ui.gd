extends CanvasLayer

@onready var label := $Panel/Label
@onready var close_button := $Panel/Button

func _ready():
	visible = false
	close_button.pressed.connect(hide_note)
	set_process_mode(PROCESS_MODE_ALWAYS)

func show_note():
	visible = true
	get_tree().paused = true

func hide_note():
	visible = false
	get_tree().paused = false
