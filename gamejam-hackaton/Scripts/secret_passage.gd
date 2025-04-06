extends Area2D
@export_node_path("Node2D") var closed_wardrobe_path
@export_node_path("Node2D") var opened_wardrobe_path

func _ready():
	# Conectăm semnalul automat
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if body.name != "player":
		return
	
	var closed_wardrobe = get_node_or_null(closed_wardrobe_path)
	var opened_wardrobe = get_node_or_null(opened_wardrobe_path)
		
	if closed_wardrobe:
		closed_wardrobe.visible = false
		
	if opened_wardrobe:
		opened_wardrobe.visible = true
