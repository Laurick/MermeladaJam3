class_name RuneButton
extends TextureButton

signal on_rune_selected(rune, selected)
	
@export var rune:Rune

func _ready():
	self.texture_normal = rune.image
	self.toggle_mode = true
	self.toggled.connect(_toggled_button)


func _toggled_button(selected):
	Audio.play_sfx("101487__earthsounds__rolling-stone-across-wood-bench.wav")
	self.modulate = Color.from_string("#33333333", Color.AQUA) if selected else Color.WHITE
	on_rune_selected.emit(self, selected)
