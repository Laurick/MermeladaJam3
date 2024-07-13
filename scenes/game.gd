extends Control

var edit_scene:PackedScene = preload("res://components/edit.tscn")
@onready var fader:Fader = $Fader
@onready var book_button = $BookButton
@onready var book = $Book
@onready var manual = $Control/Manual

@onready var runes = $Runes
@onready var stones = $Stones

var colosus = null

var state = "none"

func _ready():
	Global.reset_game()
	DialogueManager.passed_title.connect(title_pased)
	DialogueManager.mutated.connect(mutation_found)
	await get_tree().create_timer(1).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"), "intro")


func title_pased(title:String):
	if title == "name":
		show_name_edit();
	elif title == "set_stones":
		fader.force_fade_out()
		await get_tree().create_timer(2).timeout
		for rune in runes.get_children():
			create_tween().tween_property(rune, "modulate:a", 1, 0.7)
			await get_tree().create_timer(0.2).timeout
			
		for stone in stones.get_children():
			create_tween().tween_property(stone, "modulate:a", 1, 0.7)
			await get_tree().create_timer(0.2).timeout
	elif title == "read_manual":
		show_manual()
		await get_tree().create_timer(0.7).timeout
		state = "manual"

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
	DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"), "gender")


func _on_exit_button_pressed():
	Audio.play_click_sound()
	game_over()


func _on_book_button_pressed():
	Audio.play_sfx("res://sounds/422870__ipaddeh__pressure_plate_stone.wav")
	book._show()

func show_manual():
	Audio.play_sfx("Cut_560310__garuda1982__stone-rubs-grinds-on-stone-sound-effect.mp3")
	manual.text = get_tutorial_text()
	create_tween().tween_property(manual, "modulate:a", 1, 0.7)
	
func hide_manual():
	Audio.play_sfx("Cut_560310__garuda1982__stone-rubs-grinds-on-stone-sound-effect.mp3")
	create_tween().tween_property(manual, "modulate:a", 0, 0.7)

func get_tutorial_text() -> String:
	var text = ""
	if Global.gender == 0:
		text += "¡Bienvenido"
	elif Global.gender == 1:
		text += "¡Bienvenida"
	elif Global.gender == 2:
		text += "¡Bienvenide"
	text += " a tu nueva aventura en Piedras Salubles SA!\n\nComo ya te habrán informado en el curso de formación, tu deber como dependiente es ayudar a los clientes con sus necesidades más importantes. ¡Del tipo que sean! Un buen profesional siempre sabrá cuál es el producto que más le conviene a su cliente.\n\n
Para ello, lo único que tendrás que hacer es elegir las runas y piedras que mejor se ajusten a las necesidades del cliente. Fácil, ¿verdad? Desde Piedras Salubles SA nos comprometemos a facilitar todo el trabajo a nuestros empleados, de manera que, junto a este manual, habrá un vademécum en el que podrás consultar cualquier duda que tengas respecto a las piedras y a las runas. ¡Esto está chupado!\n\n
La satistacción del cliente es nuestro beneficio y, para asegurarnos de ello, cada cierto tiempo irá a visitar la tienda un representante de ventas para evaluarte. Si la opinión de la tienda es negativa, recibirás menos cargamentos de piedras y runas. ¡Pero no temas! Eso no complicará tu función aquí.\n\n
Y, ahora, ¡ponte detrás del mostrador y ayuda a cuantos más clientes puedas!\n\n
Atentamente,\nel equipo comercial de Piedras Salubres SA."
	return text


func _on_manual_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and state == "manual":
		hide_manual()
		DialogueManager.show_dialogue_balloon(load("res://dialogues/test.dialogue"), "first_customer")

func mutation_found(dict: Dictionary):
	#{ "expression": [{ "function": "show_chartacter", "type": &"function", "value": [[{ "type": "string", "value": "Venus" }]] }], "is_blocking": true }
	if dict.has("expression"):
		var expression:Dictionary = dict["expression"][0];
		if expression.has("function"):
			if expression["function"] == "new_colosus":
				var args = expression["value"][0]
				var name = args[0]["value"]
				var colosus = load("res://models/colosus/"+name+".tres")
				print("new colosus: "+name)
