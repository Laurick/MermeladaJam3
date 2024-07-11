class_name Stone
extends Resource

@export var name:String
@export var description:String
@export var image:Texture

func is_equals(stone:Stone) -> bool:
	return name == stone.name
