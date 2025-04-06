extends Area2D

@export var note_text: String  # Textul care va apărea pe foaie

func _on_area_entered(area):
	if area.name == "Player":
		var ui = get_tree().root.get_node("NoteUI")  # adaptează calea după scena ta
		ui.visible = true
		ui.get_node("Panel/RichTextLabel").text = note_text
		get_tree().paused = true  # opțional, oprește jocul cât timp citești
		queue_free()
