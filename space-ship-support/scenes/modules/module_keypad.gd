class_name ModuleKeypad
extends ShipModule
@onready var label: Label = $TextureRect/Label
@onready var texture_rect: TextureRect = $VBoxContainer/TextureRect

#@export var correct = "1234"
var current_nummber = null
var nummber_nummber
var finished = false

func add_nummber(nummber):
	if finished == false:
		print("nummer " + str(nummber))
		
		if current_nummber == null:
			current_nummber = str(nummber)
		else:
			current_nummber = current_nummber + str(nummber)
		print(str(current_nummber))
		label.text = current_nummber
		nummber_nummber = label.get_total_character_count()

		if nummber_nummber >= 4 and current_nummber != ship_id:
			current_nummber = null
			label.text = ""
			use_module(false)
			print("wrong")
		elif current_nummber == ship_id:
			print("correct")
			use_module(true)
			finished = true
		
	
	
	
	
	
	
	
	
	
	
