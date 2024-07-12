extends Control

const SHOW_TIME:float = 0.7

@onready var HIDE_POSITION = size.y * 2 

func _ready():
	position = Vector2(0, HIDE_POSITION)

func _show():
	await get_tree().create_tween().tween_property(self, "position", Vector2.ZERO, SHOW_TIME).finished

func _hide():
	await get_tree().create_tween().tween_property(self, "position", Vector2(0, HIDE_POSITION), SHOW_TIME).finished


func _on_close_button_pressed():
	_hide()
