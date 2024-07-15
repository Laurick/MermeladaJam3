class_name Ballon_Dialogue
extends CanvasLayer

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu
@onready var audio_stream_player:AudioStreamPlayer = $AudioStreamPlayer
@onready var skip_button = $Balloon/Panel/Dialogue/SkipDialogue
@onready var avatar = $Balloon/Avatar

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")
		var pj = dialogue_line.character
			
		#check tags here
		#if dialogue_line.get_tag_value("size") != "":
			#var size = dialogue_line.get_tag_value("size")
			#dialogue_label. = int(size)

		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)
		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			skip_button.visible = false
			responses_menu.show()
		elif dialogue_line.time != "":
			skip_button.visible = false
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			skip_button.visible = true
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func jump() -> void:
	var tween = create_tween()
	tween.chain().tween_property(avatar,"position",Vector2(0,120),0.2).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(avatar,"position",Vector2(0,160),0.1).set_ease(Tween.EASE_IN)
	tween.play()
	
func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	# Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and is_instance_valid(dialogue_label):
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)

func new_colosus(name:String):
	#used for mutration go to game and see the mutation
	pass
	
func show_chartacter(name:String):
	var path = "res://images/"+name+".png"
	avatar.modulate = Color.TRANSPARENT
	avatar.modulate.a = 0
	create_tween().tween_property(avatar, "modulate:a", 1, 0.7).finished
	avatar.texture = load(path)
	if name == "Tome":
		$Balloon/Magnifier.show()

func leave_chartacter():
	$Balloon/Magnifier.hide()
	await create_tween().tween_property(avatar, "modulate:a", 0, 0.7).finished
	avatar.texture = null
	avatar.modulate = Color.WHITE
	

func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

func _on_dialogue_label_spoke(letter, letter_index, speed):
	audio_stream_player.play()

#endregion

func _on_skip_dialogue_pressed():
	Audio.play_click_sound()
	var exit: bool = false
	var volume = audio_stream_player.volume_db
	audio_stream_player.volume_db = -80
	while (!exit):
		var input = InputEventMouseButton.new()
		input.button_index = MOUSE_BUTTON_LEFT
		input.pressed = true
		dialogue_line = await resource.get_next_dialogue_line(dialogue_line.next_id)
		balloon.modulate = Color.TRANSPARENT
		await get_tree().process_frame
		if (dialogue_line.responses && len(dialogue_line.responses) > 0) or (dialogue_line.text.is_empty()) or dialogue_line.type == &"title":
			exit = true
	audio_stream_player.volume_db = volume
	balloon.modulate = Color.WHITE
