class_name Rune
extends Resource

@export var name:String
@export var description:String
@export var image:Texture

func is_equals(rune:Rune) -> bool:
	return name == rune.name
