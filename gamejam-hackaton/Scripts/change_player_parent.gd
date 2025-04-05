extends Area2D

@export_node_path("Node2D") var new_parent_path
@export_node_path("Node2D") var insert_after_node

var has_moved_player := false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if has_moved_player:
		print("⏭️ Player deja mutat, ignorăm reactivarea.")
		return

	if body.name != "Player":
		return

	has_moved_player = true  # 🔒 Blocăm imediat

	var player: Node = get_tree().get_root().find_child("Player", true, false)
	if player == null:
		printerr("❌ Player nu a fost găsit în scenă.")
		return

	var new_parent = get_node_or_null(new_parent_path)
	var insert_node = get_node_or_null(insert_after_node)

	if new_parent == null:
		printerr("❌ Noul părinte este invalid.")
		return

	var is_already_child: bool = player.get_parent() == new_parent
	var already_at_position: bool = false

	if is_already_child and insert_node != null and insert_node.get_parent() == new_parent:
		var children = new_parent.get_children()
		var player_index = children.find(player)
		var insert_index = children.find(insert_node)
		already_at_position = player_index == insert_index + 1

	if is_already_child and already_at_position:
		print("ℹ️ Player este deja în ", new_parent.name, " și în poziția corectă. Nu îl mai mutăm.")
		return

	# Mutăm doar dacă NU e deja în poziția dorită
	var old_parent = player.get_parent()
	old_parent.remove_child(player)
	new_parent.add_child(player)

	if insert_node != null and insert_node.get_parent() == new_parent:
		var index = new_parent.get_children().find(insert_node)
		new_parent.move_child(player, index + 1)
		print("✅ Player mutat în ", new_parent.name, " după ", insert_node.name)
	else:
		print("⚠️ Nodul de inserare nu este valid sau nu aparține lui ", new_parent.name)

func _on_body_exited(body: Node):
	if body.name == "Player":
		await get_tree().create_timer(0.3).timeout
		has_moved_player = false
		print("🚪 Player a schimbat zona.")
