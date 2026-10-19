extends ShipModule

@onready var off: TextureRect = $On/Off



var toggle_on = false

func _on_button_button_down() -> void:
	toggle_on = not toggle_on
	if toggle_on == false:
		off.visible = false
	else:
		off.visible = true
