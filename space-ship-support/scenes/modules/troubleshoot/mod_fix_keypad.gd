extends ShipModule

@export var label: Label 

@export var correct = "1234"
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

		if nummber_nummber >= 4 and current_nummber != correct:
			current_nummber = null
			label.text = ""
			print("wrong")
		elif current_nummber == correct:
			print("correct")
			finished = true
		
