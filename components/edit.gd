extends Control

signal data_submitted(data:String)

@onready var button_submit_edit = $ButtonSubmitEdit
@onready var line_edit = $LineEdit


func _on_button_submit_edit_pressed():
	submit_text(line_edit.text)


func _on_line_edit_text_submitted(new_text:String):
	if len(new_text.strip_edges()) > 0:
		submit_text(new_text)

func submit_text(data:String):
	data_submitted.emit(data.strip_edges())
	queue_free()

func _on_line_edit_text_changed(new_text:String):
	button_submit_edit.disabled = len(new_text.strip_edges()) == 0
