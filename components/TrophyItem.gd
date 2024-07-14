extends Control

@onready var texture_icon = $IconTrophy
@onready var title_label = $TitleTrophyLabel
@onready var description_label = $DescriptionTrophyLabel
@export var trophy:Trophie

func _ready():
	if Global.is_achivements_locked(trophy.name):
		title_label.text = "?"
		description_label.text = "???"
		texture_icon.texture = preload("res://images/Logro_Base_1.png")
	else:
		title_label.text = trophy.name
		description_label.text = trophy.description
		texture_icon.texture = trophy.image
