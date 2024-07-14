extends Control

@onready var texture_icon = $IconRune
@onready var title_label = $VBoxContainer/TitleRuneLabel
@onready var description_label = $VBoxContainer/DescriptionRuneLabel
@export var rune:Rune

func _ready():
	title_label.text = rune.name
	description_label.text = rune.description.replace("\\n", "\n")
	texture_icon.texture = rune.image
