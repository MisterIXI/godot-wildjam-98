class_name ShipWindow
extends Panel

const SHIP_LAYOUT: PackedScene = preload("res://scenes/ship_spawner/ship_layout.tscn")

@export var module_parent: Control

var ship_id:String = "SHIPID"
var title_mouse_down: bool = false
var is_dragging: bool = false
var mouse_pos_offset:= Vector2i.ZERO
var partial_drag: Vector2 = Vector2.ZERO

var is_collapsed: bool = false
var collapse_tween: Tween = null

var ship_layout_data: ShipLayoutData
## danger levels: 0=fixed, 1=warning, 2=critical
var danger_level: int = 0:
	set(val):
		danger_level = val
		_update_title()

@export var title_label: RichTextLabel

func _update_title() -> void:
	match danger_level:
		1: #warning
			title_label.text = "Ship #%s Status: [pulse][color=yellow]WARNING[/color][/pulse]" % [ship_id]
		2: # critical
			title_label.text = "Ship #%s Status: [shake][color=red]CRITICAL[/color][/shake]" % [ship_id]
		_: # default
			title_label.text = "Ship #%s Status: [color=green]NORMAL[/color]" % [ship_id]
			
func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if is_dragging:
				mouse_pos_offset = event.global_position - Vector2(position)
			else:
				if position.x < -size.x or \
					position.y < -$TitleBar.size.y or \
					position.x > get_viewport_rect().size.x or \
					position.y > get_viewport_rect().size.y:
						position = Vector2(500, 200)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if collapse_tween:
				collapse_tween.kill()
			if is_collapsed:
				collapse_tween = create_tween()
				collapse_tween.tween_property(self, "size:y", 450., 0.1)
			else:
				collapse_tween = create_tween()
				collapse_tween.tween_property(self, "size:y", 30, 0.1)
			is_collapsed = not is_collapsed
	if event is InputEventMouseMotion:
		var mouse_motion:= event as InputEventMouseMotion
		if mouse_motion.button_mask  == MouseButtonMask.MOUSE_BUTTON_MASK_LEFT:
			var motion: Vector2 = mouse_motion.relative
			# print(mouse_motion.screen_velocity)
			# if mouse_motion.screen_velocity.x == 0:
			# 	motion.x = 0
			# if mouse_motion.screen_velocity.y == 0:
			# 	motion.y = 0
			position += motion

			# print(mouse_motion)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_parent().move_child(self,-1)
	
func init_ship_layout(ship_layout_data_new: ShipLayoutData) -> void:
	ship_layout_data = ship_layout_data_new
	var ship_layout: ShipLayout = SHIP_LAYOUT.instantiate() as ShipLayout
	ship_layout.init_from(ship_layout_data)
	module_parent.add_child(ship_layout)
