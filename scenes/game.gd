extends Control

@onready var fader:Fader = $Fader


func _ready():
	Global.reset_game()
	DialogueManager.passed_title.connect(title_pased)
	DialogueManager.dialogue_ended.connect(game_over.unbind(1))
	fader.force_fade_out()
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"))

func title_pased(title:String):
	print("passed: "+title)

func game_over():
	fader.fade_in()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
