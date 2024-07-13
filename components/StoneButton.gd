class_name StoneButton
extends TextureButton

signal on_stone_selected(stone, selected)

@export var stone:Stone

func _ready():
	self.texture_normal = stone.image
	self.toggle_mode = true
	self.toggled.connect(_toggled_button)

func _toggled_button(selected):
	Audio.play_sfx("101487__earthsounds__rolling-stone-across-wood-bench.wav")
	self.modulate = Color.from_string("#33333333", Color.AQUA) if selected else Color.WHITE
	on_stone_selected.emit(self, selected)
