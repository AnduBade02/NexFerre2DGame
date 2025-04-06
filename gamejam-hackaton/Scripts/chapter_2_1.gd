extends Node

func _ready():
	CutsceneBox.start_cutscene([
		"It’s cold down here. So much toxic waste. What is this?",
		"I came looking for medicine, but this doesn’t look like a storage room.",
		"Why would I ever need to hide a basement behind a fake shelf?",
		"My head’s pounding again. It’s like something’s trying to surface, but I can’t hold on to it.",
		"None of this makes sense.",
		"Wait...",
		"There's something at the far end of the room.",
		"I should check it out."
	])
