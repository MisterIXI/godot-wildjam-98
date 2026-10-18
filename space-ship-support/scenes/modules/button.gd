extends Button

@onready var mod_fix_keypad: ShipModule = $"../../../../.."


@export var nummber = 1
	
	


func _on_button_down() -> void:
	mod_fix_keypad.add_nummber(nummber)
