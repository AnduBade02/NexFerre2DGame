extends Control

@export var first_level: PackedScene

var credits_visible := false

func _ready():
	$MenuContainer/StartButton.pressed.connect(start_game)
	$MenuContainer/QuitButton.pressed.connect(quit_game)
	$MenuContainer/CreditsButton.pressed.connect(toggle_credits)

func start_game():
	get_tree().change_scene_to_packed(first_level)

func quit_game():
	get_tree().quit()

func toggle_credits():
	credits_visible = not credits_visible
	if credits_visible:
		$MenuContainer4/LeftTextLabel.text = "Made by:\nTudor Popanica\nAndu Badescu\nPetrisor Leu"
	else:
		$MenuContainer4/LeftTextLabel.text = ""
