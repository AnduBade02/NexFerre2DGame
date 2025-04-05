extends CanvasLayer

@onready var fade = $Fade
@onready var name_label = $DialogBox/NameLabel
@onready var text_label = $DialogBox/TextLabel
@onready var timer = $Timer

var full_text = ""
var char_index = 0
var typing_speed = 0.03
var on_cutscene_end: Callable = func(): pass

func start_cutscene(dialogs: Array, _on_end: Callable = func(): pass):
	visible = true
	on_cutscene_end = _on_end
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	show_dialogs(dialogs)

func show_dialogs(dialogs: Array):
	if dialogs.is_empty():
		end_cutscene()
		return

	var dialog = dialogs.pop_front()
	name_label.text = dialog.get("name", "")
	full_text = dialog.get("text", "")
	text_label.text = ""
	char_index = 0

	timer.start(typing_speed)
	timer.timeout.connect(_on_type_letter.bind(dialogs), CONNECT_ONE_SHOT)

func _on_type_letter(dialogs):
	if char_index < full_text.length():
		text_label.text += full_text[char_index]
		char_index += 1
		timer.start(typing_speed)
		timer.timeout.connect(_on_type_letter.bind(dialogs), CONNECT_ONE_SHOT)
	else:
		await get_tree().create_timer(0.5).timeout
		await wait_for_input()
		show_dialogs(dialogs)

func wait_for_input():
	while not Input.is_action_just_pressed("ui_accept"):
		await get_tree().process_frame

func end_cutscene():
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	visible = false
	on_cutscene_end.call()
