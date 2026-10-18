extends ShipModule

@export var label: Label 

#@export var correct = "" # uses ship id insteaad
var current_nummber = null
var nummber_nummber


func add_nummber(nummber):
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
	elif current_nummber == ship_id:
		use_module(true)
	
