class_name ShipWindow
extends Panel

var title_mouse_down: bool = false
var is_dragging: bool = false
var mouse_pos_offset:= Vector2i.ZERO
var partial_drag: Vector2 = Vector2.ZERO

var is_collapsed: bool = false
var collapse_tween: Tween = null

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
