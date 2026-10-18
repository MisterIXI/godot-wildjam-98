class_name Ship
extends Area2D

signal on_destroy(id: String, was_fixed: bool)

@onready var target_sprite: Sprite2D = $TargetSprite
@onready var target: Timer = $Target

var ship_id: String
var y_mod
var x_mod
var ship_offset
var ship_Position
var offset_y
var offset_plus
var target_close = false
var ship_direction: Vector2
var ship_speed: float = 40

var ship_window: ShipWindow = null

func _physics_process(delta: float) -> void:
	position += ship_direction * ship_speed * delta
	if position.length() > 360:
		#TODO: check if ship is fixed when leaving area
		on_destroy.emit(true)
		#TODO: add destroy/close animation
		ship_window.queue_free()
		queue_free()
		# print("Kaputt!")


#Target animation
func _on_target_timeout() -> void:
	target_close = not target_close
	if target_close == true:
		target_sprite.frame = 1
	else:
		target_sprite.frame = 0
	

#When clicked
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and target_sprite.visible == true:
		ship_window.show()



func _on_mouse_entered() -> void:
	get_tree().call_group("ship","target_disapear")
	target_sprite.visible = true
	
func target_disapear():
	target_sprite.visible = false


func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	# #TODO: check if ship is fixed when leaving area
	# on_destroy.emit(true)
	# queue_free()
	pass

func init_layout(layout_data: ShipLayoutData) -> void:
	ship_window.init_ship_layout(layout_data)
