class_name WobbleComponent
extends Node

@export var big_scale:Vector2 = Vector2(1.1, 1.1)
@export var small_scale:Vector2 = Vector2(0.9, 0.9)
@export var time:float = 0.5
@export var target: Node
@export var auto_start:bool = true

var running:bool = false
var tween:Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	if target:
		target.pivot_offset = Vector2(target.size.x/2, target.size.y/2)
	if auto_start:
		running = true
		expand()

func start():
	running = true
	expand()
	
func stop():
	running = false
	tween = get_tree().create_tween()
	tween.tween_property(target, "scale", Vector2.ONE, 0.1)

func expand():
	tween = get_tree().create_tween()
	tween.tween_property(target, "scale", big_scale, time)
	if running:
		tween.finished.connect(contract)

func contract():
	tween = get_tree().create_tween()
	tween.tween_property(target, "scale", small_scale, time)
	if running:
		tween.finished.connect(expand)
