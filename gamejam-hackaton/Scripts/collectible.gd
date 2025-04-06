extends Area2D

@export var note_ui_index: int = 1  # 1, 2 sau 3

func _ready():
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.name != "player":
		return

	match note_ui_index:
		1:
			if not NoteUi.visible:
				NoteUi.show_note()
				queue_free()
		2:
			if not Note2Ui.visible:
				Note2Ui.show_note()
				queue_free()
		3:
			if not Note3Ui.visible:
				Note3Ui.show_note()
				queue_free()
