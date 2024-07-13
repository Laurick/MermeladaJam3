extends Control

var edit_scene:PackedScene = preload("res://components/edit.tscn")
@onready var fader:Fader = $Fader
@onready var book_button = $VBoxContainer/TrophiesButton
@onready var book = $Book
@onready var manual = $ControlManual/Manual
@onready var control_trophies = $ControlTrophies
@onready var trophy_achivements = $TrophyAchivements

@onready var give_button = $GiveButton

@onready var runes = $Runes
@onready var stones = $Stones

var colosus:Colosus = null

var state = "none"

var stones_selected:Array[StoneButton] = []
var runes_selected:Array[RuneButton] = []

func _ready():
	Global.reset_game()
	DialogueManager.passed_title.connect(title_pased)
	DialogueManager.mutated.connect(mutation_found)
	Global.achivement_unlocked.connect(show_achivement)
	await get_tree().create_timer(1).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), "intro")
	book.book_closed.connect(on_book_closed)


func title_pased(title:String):
	if title == "name":
		show_name_edit();
	elif title == "set_stones":
		fader.force_fade_out()
		await get_tree().create_timer(2).timeout
		for rune:RuneButton in runes.get_children():
			rune.on_rune_selected.connect(rune_selected)
			create_tween().tween_property(rune, "modulate:a", 1, 0.6)
			await get_tree().create_timer(0.1).timeout
			
		for stone:StoneButton in stones.get_children():
			stone.on_stone_selected.connect(stone_selected)
			create_tween().tween_property(stone, "modulate:a", 1, 0.6)
			await get_tree().create_timer(0.1).timeout
	elif title == "read_manual":
		show_manual()
		await get_tree().create_timer(0.7).timeout
		state = "manual"
	elif title == "open_vademecum":
		_on_book_button_pressed()
		state = "vademecum"
	elif title == "wait_for_riddle":
		state = "wait_for_riddle"
		give_button.visible = true
		stones_selected = []
		runes_selected = []
	elif title == "continue_for_riddle":
		give_button.visible = true

func game_over():
	fader.fade_in()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func show_name_edit():
	var edit_instance = edit_scene.instantiate()
	edit_instance.data_submitted.connect(on_name_summited)
	add_child(edit_instance)

func on_name_summited(new_text):
	Global.player_name = new_text
	DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), "gender")


func _on_exit_button_pressed():
	Audio.play_click_sound()
	game_over()


func _on_book_button_pressed():
	Audio.play_sfx("res://sounds/422870__ipaddeh__pressure_plate_stone.wav")
	book._show()

func on_book_closed():
	if state == "vademecum":
		DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), "close_vademecum")

func show_manual():
	Audio.play_sfx("Cut_560310__garuda1982__stone-rubs-grinds-on-stone-sound-effect.mp3")
	manual.text = get_tutorial_text()
	manual.get_parent().show()
	await create_tween().tween_property(manual, "modulate:a", 1, 0.7).finished
	
func hide_manual():
	Audio.play_sfx("Cut_560310__garuda1982__stone-rubs-grinds-on-stone-sound-effect.mp3")
	await create_tween().tween_property(manual, "modulate:a", 0, 0.7).finished
	manual.get_parent().hide()

func get_tutorial_text() -> String:
	var text = ""
	if Global.gender == 0:
		text += "¡Bienvenido"
	elif Global.gender == 1:
		text += "¡Bienvenida"
	elif Global.gender == 2:
		text += "¡Bienvenide"
	text += "  a tu nueva aventura en Piedras Salubres SA!\n\nComo ya te habrán informado en el curso de formación, tu deber como dependiente es ayudar a los clientes con sus necesidades más importantes. ¡Del tipo que sean! Un
buen profesional siempre sabrá cuál es el producto que más le conviene a su cliente.\n\nPara ello, lo único que tendrás que hacer es elegir las runas y la piedra que mejor seajusten a las necesidades del cliente. Fácil, ¿verdad? Desde Piedras Salubres SA noscomprometemos a facilitar todo el trabajo a nuestros empleados, de manera que,junto a este manual, habrá un vademécum en el que podrás consultar cualquier dudaque tengas con respecto a las piedras y a las runas. ¡Esto está chupado\n\nLa satisfacción del cliente es nuestro benecio y, para asegurarnos de ello, cada ciertotiempo irá a visitar la tienda un representante de ventas para evaluarte. Si la opiniónde la tienda es negativa, recibirás menos cargamentos de piedras y runas. ¡Pero notemas! Eso no complicará tu función aquí.\n\nY, ahora, ¡ponte detrás del mostrador y ayuda a cuantos más clientes puedas!\n\nAtentamente, el equipo comercial de Piedras Salubres SA."
	return text

func rune_selected(rune:RuneButton, is_selected):
	if is_selected:
		if len(runes_selected) >= 2:
			runes_selected[0].button_pressed = false
			runes_selected.push_back(rune)
		else:
			runes_selected.push_back(rune)
	else:
		runes_selected.erase(rune)

func stone_selected(stone:StoneButton, is_selected):
	if is_selected:
		if len(stones_selected) >= 1:
			stones_selected[0].button_pressed = false
			stones_selected.push_back(stone)
		else:
			stones_selected.push_back(stone)
	else:
		stones_selected.erase(stone)

func _on_manual_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and state == "manual":
		hide_manual()
		DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), "find_vademecum")

func mutation_found(dict: Dictionary):
	if dict.has("expression"):
		var expression:Dictionary = dict["expression"][0];
		if expression.has("function"):
			if expression["function"] == "new_colosus":
				var args = expression["value"][0]
				var name = args[0]["value"]
				colosus = load("res://models/colosus/"+name+".tres")


func _on_give_button_pressed():
	give_button.visible = false
	if len(runes_selected) < 2 or len(stones_selected) < 1:
		DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), "error_spell")
	else:
		var spell = Spell.new()
		for rune_selected in runes_selected:
			spell.runes.push_front(rune_selected.rune)
		for stone_selected in stones_selected:
			spell.stones.push_front(stone_selected.stone)
		
		if colosus.needs.is_equals(spell):
			Global.unlock_achivement(colosus.name)
			Global.change_score_by(1)
			Global.add_customer_mood(colosus.name, true)
		else:
			Global.change_score_by(-1)
			Global.add_customer_mood(colosus.name, false)

		DialogueManager.show_dialogue_balloon(load("res://dialogues/day1.dialogue"), colosus.name+"_end")


func _on_trophies_button_pressed():
	control_trophies.show()


func _on_back_trophies_button_pressed():
	control_trophies.hide()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_B:
		show_achivement(load("res://models/trophies/Venus.tres"))
		
func show_achivement(achivement):
	Audio.play_sfx("427570__maria_mannone__flute-a-short-sequence.wav")
	trophy_achivements.setup(achivement)
	await get_tree().create_tween().tween_property(trophy_achivements, "position", Vector2(trophy_achivements.position.x,trophy_achivements.position.y+150), 0.5).finished
	await get_tree().create_timer(2).timeout
	get_tree().create_tween().tween_property(trophy_achivements, "position", Vector2(trophy_achivements.position.x,trophy_achivements.position.y-150), 0.2).finished
