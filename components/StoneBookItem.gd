extends Control

@onready var texture_icon = $IconStone
@onready var title_label = $VBoxContainer/TitleStoneLabel
@onready var description_label = $VBoxContainer/DescriptionStoneLabel
@export var stone:Stone

func _ready():
	title_label.text = stone.name
	description_label.text = stone.description.replace("\\n", "\n")
	texture_icon.texture = stone.image
