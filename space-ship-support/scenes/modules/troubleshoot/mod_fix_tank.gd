extends ShipModule
@onready var progress_bar: ProgressBar = $ProgressBar

var scroll_value = 100
@export var correct_position = 1
var fluid_change = 100

var progress_target = 100

func _on_v_scroll_bar_value_changed(value: float) -> void:
	fluid_change =  scroll_value - value
	scroll_value = value
	progress_target = value
	
	
func _process(delta: float) -> void:
	if progress_target > progress_bar.value:
		progress_bar.value += 100 * delta
	elif progress_target < progress_bar.value:
			progress_bar.value -= 100 * delta

func _on_button_button_down() -> void:
	if correct_position == 1:
		if scroll_value < 21:
			_correkt()
		else:
			_wrong()
	elif correct_position == 2:
		if scroll_value > 30 and scroll_value < 70:
			_correkt()
		else:
			_wrong()
	elif correct_position == 3:
		if scroll_value > 79:
			_correkt()
		else:
			_wrong()
		
func _correkt():
	print("Correkt")
	use_module(true)
		
func _wrong():
	print("Wrong")
	use_module(false)
