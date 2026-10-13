extends Area2D

var y_mod
var x_mod
var ship_speed
var ship_offset
var ship_Position
var offset_y

func ship_setup(Position,speed,offset):
	ship_speed = speed
	ship_offset = offset
	if Position < 1:
		ship_Position = 1
		x_mod = 0
		y_mod = 1
	elif Position < 2:
		ship_Position = 2
		x_mod = -0.5
		y_mod = 0.5
	elif Position < 3:
		ship_Position = 3
		x_mod = -1
		y_mod = 0
	elif Position < 4:
		ship_Position = 4
		x_mod = -0.5
		y_mod = -0.5
	elif Position < 5:
		ship_Position = 5
		x_mod = 0
		y_mod = -1
	elif Position < 6:
		ship_Position = 6
		x_mod = 0.5
		y_mod = -0.5
	elif Position < 7:
		ship_Position = 7
		x_mod = 1
		y_mod = 0
	elif Position < 8:
		ship_Position = 8
		y_mod = 0.5
		x_mod = 0.5
	#use the decimels on the generated nummber for a another random outcome
	if Position - ship_Position + 1 >= 0.5:
		offset_y = true
	else:
		offset_y = false

	
	
	
func _process(delta: float) -> void:
	if ship_Position == 2 or ship_Position == 4 or ship_Position == 6 or ship_Position == 8:
		#Position controlls for the X flying ships
		if offset_y == true:
			position.y += ship_speed * y_mod * delta * ship_offset
			position.x += ship_speed * x_mod * delta / ship_offset
		else:
			position.y += ship_speed * y_mod * delta / ship_offset
			position.x += ship_speed * x_mod * delta * ship_offset
			#Position controlls for the + flying ships
	elif  ship_Position == 1 or ship_Position == 5:
			position.y += ship_speed * delta / ship_offset
			position.x += ship_speed * 0.5 / ship_offset * delta
	elif ship_Position == 3 or ship_Position == 7:
			position.y += ship_speed * 0.5 / ship_offset * delta
			position.x += ship_speed * delta / ship_offset
		
		
		
		
		
		
		
		
