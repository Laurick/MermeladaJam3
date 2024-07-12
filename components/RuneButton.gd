class_name RuneButton
extends TextureButton

@export var rune:Rune

func _ready():
	self.texture_normal = rune.image
	self.toggle_mode = true
	self.button_group = preload("res://misc/runes_button_group.tres")
