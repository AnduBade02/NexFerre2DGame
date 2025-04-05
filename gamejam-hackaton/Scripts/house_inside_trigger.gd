extends Area2D

@export_node_path("Node2D") var player_path
@export_node_path("Node2D") var interior_layer_path
@export_node_path("Node2D") var walls_front_layer_path

var has_moved_player := false

func _ready():
	# Conectăm semnalul automat
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if has_moved_player:
		return
	if body.name != "Player":
		return

	var player = get_node_or_null(player_path)
	if player == null:
		print("❌ player_path invalid.")
		return

	var interior = get_node_or_null(interior_layer_path)
	var walls_front = get_node_or_null(walls_front_layer_path)
	if interior == null or walls_front == null:
		print("❌ Unul dintre layerele de referință lipsește.")
		return

	var parent = player.get_parent()
	if parent == null:
		print("❌ Player nu are părinte.")
		return

	var children = parent.get_children()
	var player_index = children.find(player)
	var interior_index = children.find(interior)
	var walls_index = children.find(walls_front)

	var is_between = player_index > interior_index and player_index < walls_index

	if is_between:
		print("✅ Player este deja între layere. Nu mutăm.")
	else:
		var insert_index = walls_index

		# Dacă Player e mai sus decât interiorul, mutăm cu 1 mai jos
		if player_index < interior_index:
			insert_index -= 1

		parent.move_child(player, insert_index)
		print("✅ Player mutat la index ", insert_index)
	
	has_moved_player = true

func _on_body_exited(body: Node):
	if body.name == "Player":
		has_moved_player = false
