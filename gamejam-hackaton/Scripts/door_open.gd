extends Area2D
@export_node_path("Node2D") var closed_door_path
@export_node_path("Node2D") var opened_door_path

func _ready():
	# Conectăm semnalul automat
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):

	var closed_door = get_node_or_null(closed_door_path)
	var opened_door = get_node_or_null(opened_door_path)
		
	if closed_door:
		closed_door.visible = false
		
	if opened_door:
		opened_door.visible = true
