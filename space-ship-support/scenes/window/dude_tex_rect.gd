extends TextureRect

@export var dudes: Array[Texture2D]

func _ready() -> void:
	texture = dudes.pick_random()