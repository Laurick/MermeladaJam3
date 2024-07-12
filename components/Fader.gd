class_name Fader
extends ColorRect

func fade_in():
	await get_tree().create_tween().tween_property(self,"color:a",1,2).finished
	mouse_filter = Control.MOUSE_FILTER_STOP

func fade_out():
	await get_tree().create_tween().tween_property(self,"color:a",0,2).finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func force_fade_out():
	color.a = 1
	await get_tree().create_tween().tween_property(self,"color:a",0,2).finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE
