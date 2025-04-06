extends Node

func _ready():
	if Global.pages_collected >= 3:
		play_good_ending()
	else:
		play_bad_ending()

func play_good_ending():
	CutsceneBox.start_cutscene([
		"...Joel.",
		"I remember now. God... I remember everything.",
		"*His knees weaken. A sharp, suffocating pressure builds behind his eyes.*",
		"Joel: So, the great Nex Ferre finally remembers.",
		"Joel: You said you wanted to save the world, and you destroyed it instead.",
		"Joel: And Damien... He trusted you. We both did.",
		"*Nex lowers his head. He doesn’t argue.*",
		"I didn’t mean for this. I was trying to help. I thought I could fix it all...",
		"Joel: You tested it on him. On your friend. And then you ran.",
		"I was broken, Joel. I still am.",
		"But my daughter… Lucinda… she’s innocent.",
		"*Nex’s voice trembles.*",
		"I know I don’t deserve anything, but please… there must be some medicine here. She needs it.",
		"*Joel looks at him, eyes torn between rage and something softer—memory.*",
		"Joel: For her. Not for you.",
		"*Joel raises the pistol. Nex closes his eyes.*",
		"I’m sorry.",
	])
	await CutsceneBox.cutscene_finished
	finish_chapter()


func play_bad_ending():
	CutsceneBox.start_cutscene([
		"...Joel?",
		"I... I remember things now. Bits and pieces.",
		"I remember trying to save lives. I was doing what no one else dared.",
		"Joel: Save lives? Is that what you call it?",
		"Joel: You killed Damien. You brought this world to its knees.",
		"I gave everything I had to stop the spread. You—you were always afraid to take real action.",
		"Joel: I warned you. I begged you to slow down. But you treated ethics like obstacles.",
		"Spare me the lecture. You sat on your hands while I tried to change the world.",
		"Joel: You changed it, alright. Into hell.",
		"You're just bitter I was right.",
		"*Joel tightens his grip on the pistol.*",
		"Joel: Right? Lucinda’s dead because of you. You forgot the vial. You forgot her.",
		"*Nex’s face falters.*",
		"She... what?",
		"*Joel doesn't answer. The silence says enough.*",
		"Joel: You lost the right to ask anything.",
		"*A shot rings out. No mercy. No forgiveness.*"
	])
	await CutsceneBox.cutscene_finished
	finish_chapter()

func finish_chapter():
	if Global.pages_collected >= 3:
		GameOver1.show_death()
	else:
		GameOver2.show_death()
	
