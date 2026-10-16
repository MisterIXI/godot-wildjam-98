extends Control
@onready var label: Label = $TextureRect/Label
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

var current_nummber = null
var nummber_nummber

func add_nummber(nummber):
	print("nummer " + str(nummber))
	
	if current_nummber == null:
		current_nummber = str(nummber)
	else:
		current_nummber = current_nummber + str(nummber)
	print(str(current_nummber))
	label.text = current_nummber
	nummber_nummber = label.get_total_character_count()

	if nummber_nummber >= 4:
		var tween = create_tween()
		tween.tween_property(texture_rect,"modulate","e50031",10)
		current_nummber = null
		label.text = ""
		
		
	
	
	
	
	
	
	
