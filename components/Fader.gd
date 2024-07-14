class_name Fader
extends ColorRect

func fade_to_color(color:Color):
	await get_tree().create_tween().tween_property(self, "color", color, 2).finished
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func fade_in():
	color = Color.BLACK
	color.a = 0
	await get_tree().create_tween().tween_property(self,"color:a",1,2).finished
	mouse_filter = Control.MOUSE_FILTER_STOP

func fade_out():
	color = Color.BLACK
	color.a = 1
	await get_tree().create_tween().tween_property(self,"color:a",0,2).finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func force_fade_out():
	color = Color.BLACK
	color.a = 1
	await get_tree().create_tween().tween_property(self,"color:a",0,2).finished
	mouse_filter = Control.MOUSE_FILTER_IGNORE
