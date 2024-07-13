class_name Trophie 
extends Resource

@export var name:String
@export var description:String
#@export var state:String (#Patrick: para definir si el trofeo ha sido conseguido o no? o eso iría en una global? o las dos cosas?) 
@export var image:Texture

func is_equals(trophie:Trophie) -> bool:
	return name == trophie.name
