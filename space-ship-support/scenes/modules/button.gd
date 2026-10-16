extends TextureRect
@onready var module_keypad: Control = $"../../.."
@onready var label: Label = $Label

@export var nummber = 1

func _ready() -> void:
	label.text = str(nummber)

func _on_button_button_down() -> void:
	module_keypad.add_nummber(nummber)
	
