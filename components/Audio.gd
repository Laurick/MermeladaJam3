extends Node

@onready var audio_stream_player_music:AudioStreamPlayer = $AudioStreamPlayerMusic
@onready var audio_stream_player_ui:AudioStreamPlayer = $AudioStreamPlayerUI
@onready var audio_stream_player_sfx:AudioStreamPlayer = $AudioStreamPlayerSFX

func _ready():
	audio_stream_player_music.volume_db = linear_to_db(0.5)
	audio_stream_player_ui.volume_db = linear_to_db(0.5)
	audio_stream_player_sfx.volume_db = linear_to_db(0.5)
	
func set_music_value(value:float):
	audio_stream_player_music.volume_db = linear_to_db(value)

func set_sfx_value(value:float):
	audio_stream_player_ui.volume_db = linear_to_db(value)
	audio_stream_player_sfx.volume_db = linear_to_db(value)

func play_test_sound():
	audio_stream_player_ui.stream = preload("res://sounds/tone1.ogg")
	audio_stream_player_ui.play()

func play_click_sound():
	audio_stream_player_ui.stream = preload("res://sounds/333038__christopherderp__videogame-menu-button-clicking-sound-13.wav")
	audio_stream_player_ui.play()

func play_music_by_path(music_path:String):
	audio_stream_player_music.stop()
	audio_stream_player_music.stream = load(music_path)
	audio_stream_player_music.play()

func play_music(music:AudioStream):
	if audio_stream_player_music.stream != music:
		audio_stream_player_music.stream = music
		audio_stream_player_music.play()

func play_ui(sound:String, random_pitch:bool = false):
	audio_stream_player_ui.stream = load("res://sounds/%s" % sound)
	if random_pitch: 
		audio_stream_player_ui.pitch_scale = randf_range(0.95,1.05)
	else:
		audio_stream_player_ui.pitch_scale = 1
	audio_stream_player_ui.play()
	
func play_sfx(sound:String):
	audio_stream_player_sfx.stream = load("res://sounds/%s" % sound)
	audio_stream_player_sfx.play()

func stop_music():
	audio_stream_player_music.stop()

func resume_music():
	audio_stream_player_music.play()

var index_music_bus = -1
func play_music_with_fade_in(music:AudioStream, from:float=0.0):
	index_music_bus = AudioServer.get_bus_index("Music");
	var tween = get_tree().create_tween()
	tween.tween_method(_set_audio_volume, from, db_to_linear(audio_stream_player_music.volume_db), 4)
	tween.play()
	play_music(music)

func _set_audio_volume(volume:float):
	AudioServer.set_bus_volume_db(index_music_bus, linear_to_db(volume))
