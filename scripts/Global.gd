extends Node

#he/him = 0
#she/her = 1
#they/them = 2
var gender: int = -1
var score: int = 0
var affection_tomeu: int = 0
var player_name

func reset_game():
	gender = -1
	score = 0
	affection_tomeu = 0
	player_name = ""
