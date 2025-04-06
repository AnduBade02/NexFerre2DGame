extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	if visible and event.is_action_pressed("ui_cancel"):  # ESC implicit
		visible = false
		get_tree().paused = false
