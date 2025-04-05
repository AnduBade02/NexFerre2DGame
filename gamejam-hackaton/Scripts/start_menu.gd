extends Control

@export var first_level: PackedScene  # Aici alegi prima scenă

func _ready():
	$MenuContainer/StartButton.pressed.connect(start_game)
	$MenuContainer/QuitButton.pressed.connect(quit_game)

func start_game():
	get_tree().change_scene_to_packed(first_level)

func quit_game():
	get_tree().quit()
