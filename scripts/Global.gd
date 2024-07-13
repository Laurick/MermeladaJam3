extends Node

signal achivement_unlocked(archivement)

#he/him = 0
#she/her = 1
#they/them = 2
var gender: int = -1
var score: int = 0
var affection_tomeu: int = 0
var player_name
var achivements_unlocked = {}

func _ready():
	load_score()

func reset_game():
	gender = -1
	score = 0
	affection_tomeu = 0
	player_name = ""

var save_path = "user://achivements.save"

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(achivements_unlocked)

func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		achivements_unlocked = file.get_var()
	else:
		achivements_unlocked = {}

func unlock_achivement(name:String):
	if !achivements_unlocked.has(name):
		achivements_unlocked[name] = true
		if len(achivements_unlocked) == 9:
			achivements_unlocked["Colosal"] = true
		achivement_unlocked.emit(load("res://models/trophies/"+name+".tres"))
		save_score()

func is_achivements_locked(name:String):
	if achivements_unlocked.has(name):
		return achivements_unlocked[name]
	else:
		return true
