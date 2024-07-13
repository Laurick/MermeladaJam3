class_name Spell
extends Resource

@export var runes:Array[Rune]
@export var stones:Array[Stone]

func is_equals(spell:Spell) -> bool:
	var found_runes:bool = true
	for rune in runes:
		found_runes = found_runes and find_rune(spell.runes, rune)
	for rune in spell.runes:
		found_runes = found_runes and find_rune(runes, rune)
	
	var found_stones:bool = true
	for stone in stones:
		found_stones = found_stones and find_stones(spell.stones, stone)
	for stone in spell.stones:
		found_stones = found_stones and find_stones(stones, stone)
	return found_runes and found_stones

func find_rune(runes:Array[Rune], rune:Rune):
	var found = false
	var index = 0
	while !found and index < len(runes):
		var r = runes[index]
		found = r.is_equals(rune)
		index+=1
	return found

func find_stones(stones:Array[Stone], stone:Stone):
	var found = false
	var index = 0
	while !found and index < len(stones):
		var s = stones[index]
		found = s.is_equals(stone)
		index+=1
	return found
