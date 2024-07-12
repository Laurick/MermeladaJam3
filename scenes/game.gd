extends Control

var edit_scene:PackedScene = preload("res://components/edit.tscn")
@onready var fader:Fader = $Fader
@onready var book_button = $BookButton
@onready var book = $Book


func _ready():
	Global.reset_game()
	DialogueManager.passed_title.connect(title_pased)
	fader.force_fade_out()
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"), "intro")

func title_pased(title:String):
	if title == "name":
		show_name_edit();

func game_over():
	fader.fade_in()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func show_name_edit():
	var edit_instance = edit_scene.instantiate()
	edit_instance.data_submitted.connect(on_name_summited)
	add_child(edit_instance)

func on_name_summited(new_text):
	Global.player_name = new_text
	DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"), "gender")


func _on_exit_button_pressed():
	game_over()


func _on_book_button_pressed():
	book._show()
