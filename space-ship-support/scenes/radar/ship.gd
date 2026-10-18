class_name Ship
extends Area2D

signal on_destroy(id: String, was_fixed: bool)

@onready var target_sprite: Sprite2D = $TargetSprite
@onready var target: Timer = $Target

var ship_id: String
var y_mod
var x_mod
var ship_speed
var ship_offset
var ship_Position
var offset_y
var offset_plus
var target_close = false

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
	if Position - ship_Position + 1.1 >= 0.5:
		offset_y = true
		offset_plus = 0.5
	else:
		offset_y = false
		offset_plus = -0.5
	
	
	
func _process(delta: float) -> void:
	#movement of the ships
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
			position.y += ship_speed * y_mod * delta / ship_offset
			position.x += ship_speed * offset_plus * delta / ship_offset 
	elif ship_Position == 3 or ship_Position == 7:
			position.y += ship_speed * offset_plus * delta / ship_offset 
			position.x += ship_speed * x_mod * delta / ship_offset
			

#Target animation
func _on_target_timeout() -> void:
	target_close = not target_close
	if target_close == true:
		target_sprite.frame = 1
	else:
		target_sprite.frame = 0
	

#When clicked
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and target_sprite.visible == true:
		print("Open ship window")



func _on_mouse_entered() -> void:
	get_tree().call_group("ship","target_disapear")
	target_sprite.visible = true
	
func target_disapear():
	target_sprite.visible = false


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	#TODO: check if ship is fixed when leaving area
	on_destroy.emit(true)
	queue_free()
