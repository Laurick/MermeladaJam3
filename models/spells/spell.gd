class_name Spell
extends Resource

@export var runes:Array[Rune]
@export var stones:Array[Stone]

func is_equals(spell:Spell) -> bool:
	var found_runes:bool = true
	for rune in runes:
		found_runes = found_runes and spell.runes.find(rune)
	for rune in spell.runes:
		found_runes = found_runes and runes.find(rune)
	
	var found_stones:bool = true
	for stone in stones:
		found_stones = found_stones and spell.stones.find(stone)
	for stone in spell.runes:
		found_stones = found_stones and stones.find(stone)
	return found_runes and found_stones
