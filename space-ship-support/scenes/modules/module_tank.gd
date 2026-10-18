extends Control
@onready var fluid: TextureRect = $fluid

var scroll_value = 100
@export var correct_position = 4
var fluid_change = 0

func _on_v_scroll_bar_value_changed(value: float) -> void:
	fluid_change =  scroll_value - value
	scroll_value = value
	fluid.size.y += fluid_change * 1.2





func _on_button_button_down() -> void:
	if correct_position == 1:
		if scroll_value < 11:
			_correkt()
		else:
			_wrong()
	elif correct_position == 2:
		if scroll_value > 24 and scroll_value < 41:
			_correkt()
		else:
			_wrong()
	elif correct_position == 3:
		if scroll_value > 54 and scroll_value < 71:
			_correkt()
		else:
			_wrong()
	elif correct_position == 4:
		if scroll_value > 89:
			_correkt()
		else:
			_wrong()
		
func _correkt():
	print("Correkt")
	
func _wrong():
	print("Wrong")
