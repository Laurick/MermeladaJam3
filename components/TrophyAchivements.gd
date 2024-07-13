extends Control

@onready var texture_icon = $IconTrophy
@onready var title_label = $TitleTrophyLabel
@onready var description_label = $DescriptionTrophyLabel

func setup(trophy:Trophie):
	title_label.text = trophy.name
	description_label.text = trophy.description
	texture_icon.texture = trophy.image
