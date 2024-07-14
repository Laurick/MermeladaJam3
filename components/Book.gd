extends Control

signal book_closed()

const SHOW_TIME:float = 0.7

@onready var HIDE_POSITION = size.y * 2 

func _ready():
	#position = Vector2(0, HIDE_POSITION)
	pass

func _show():
	Audio.play_sfx("422870__ipaddeh__pressure_plate_stone.wav")
	await get_tree().create_tween().tween_property(self, "position", Vector2.ZERO, SHOW_TIME).finished

func _hide():
	Audio.play_sfx("422870__ipaddeh__pressure_plate_stone.wav")
	await get_tree().create_tween().tween_property(self, "position", Vector2(0, HIDE_POSITION), SHOW_TIME).finished


func _on_close_button_pressed():
	_hide()
	book_closed.emit()
