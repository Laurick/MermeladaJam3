extends Control

func _ready():
	Audio.play_music_with_fade_in(load("res://sounds/Menu.mp3"))

func _on_play_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_credits_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
