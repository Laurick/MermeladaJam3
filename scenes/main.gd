extends Control

@onready var play_button = $HBoxContainer/PlayButton
@onready var options_button = $HBoxContainer/OptionsButton
@onready var trophies_button = $HBoxContainer/TrophiesButton
@onready var credits_button = $HBoxContainer/CreditsButton

func _ready():
	Audio.play_music_with_fade_in(load("res://sounds/Menu.mp3"))
	await get_tree().create_timer(6).timeout
	create_tween().tween_property(play_button, "modulate:a", 1, 0.7)
	create_tween().tween_property(options_button, "modulate:a", 1, 0.7)
	create_tween().tween_property(trophies_button, "modulate:a", 1, 0.7)
	create_tween().tween_property(credits_button, "modulate:a", 1, 0.7)
	
func _on_play_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/options.tscn")


func _on_credits_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_trophies_button_pressed():
	Audio.play_click_sound()
	get_tree().change_scene_to_file("res://scenes/thropies.tscn")
