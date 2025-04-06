extends Area2D

@export var note_ui_index: int = 1  # ID unic pentru foaie

func _ready():
	if Global.collected_pages.has(note_ui_index):
		queue_free()
	else:
		body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.name != "player":
		return

	Global.collect_page(note_ui_index)

	match note_ui_index:
		1:
			if not NoteUi.visible:
				NoteUi.show_note()
		2:
			if not Note2Ui.visible:
				Note2Ui.show_note()
		3:
			if not Note3Ui.visible:
				Note3Ui.show_note()

	# Așteaptă să se audă sunetul înainte să dispară foaia
	await get_tree().create_timer(0.3).timeout  # ajustează timpul după sunet
	queue_free()
