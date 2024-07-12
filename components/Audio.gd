extends Node

@onready var audio_stream_player_music:AudioStreamPlayer = $AudioStreamPlayerMusic
@onready var audio_stream_player_ui:AudioStreamPlayer = $AudioStreamPlayerUI
@onready var audio_stream_player_sfx:AudioStreamPlayer = $AudioStreamPlayerSFX

func set_music_value(value:float):
	audio_stream_player_music.volume_db = linear_to_db(value)

func set_sfx_value(value:float):
	audio_stream_player_ui.volume_db = linear_to_db(value)

func play_test_sound():
	audio_stream_player_ui.stream = load("res://sounds/tone1.ogg")
	audio_stream_player_ui.play()

func play_click_sound():
	audio_stream_player_ui.stream = load("res://sounds/click3.ogg")
	audio_stream_player_ui.play()

func play_music(music:AudioStream):
	if audio_stream_player_music.stream != music:
		audio_stream_player_music.stream = music
		audio_stream_player_music.play()

func play_ui(sound:String, random_pitch:bool = false):
	audio_stream_player_ui.stream = load("res://music/%s" % sound)
	if random_pitch: 
		audio_stream_player_ui.pitch_scale = randf_range(0.95,1.05)
	else:
		audio_stream_player_ui.pitch_scale = 1
	audio_stream_player_ui.play()
	
func play_sfx(sound:String):
	audio_stream_player_sfx.stream = load("res://music/%s" % sound)
	audio_stream_player_sfx.play()

func stop_music():
	audio_stream_player_music.stop()

func resume_music():
	audio_stream_player_music.play()
