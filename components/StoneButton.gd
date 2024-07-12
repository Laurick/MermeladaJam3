class_name StoneButton
extends TextureButton

@export var stone:Stone

func _ready():
	self.texture_normal = stone.image
	self.toggle_mode = true
	self.button_group = preload("res://misc/runes_button_group.tres")
