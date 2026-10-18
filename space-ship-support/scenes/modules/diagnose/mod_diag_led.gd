class_name ModDiagLed
extends ShipModule

const LED_OFF: Texture = preload("uid://cato5r3tfjfmh")
const LED_ON: Texture = preload("uid://ckbgs37itstca")

@export var led_on_color: Color
@export var led_off_color: Color
@export var leds: Array[TextureRect]


## called when all relevant data (module data, puzzle slots) is linked
func _on_init_finished() -> void:
	load_from_code()

func load_from_code() -> void:
	for i in leds.size():
		
		if (puzzle_code.size() <= i):
			break
			push_warning("code: ", "|".join(puzzle_code), " is too small for the number of leds (9)")
			
		var code_active: bool = puzzle_code[i] == "1" || puzzle_code[i] == "on"
					
		set_led_active(i, code_active)

func set_led_active(index: int, led_active: bool) -> void:
	var led: TextureRect = leds[index]
	led.texture = LED_ON if led_active else LED_OFF
	led.modulate = led_on_color if led_active else led_off_color
	
