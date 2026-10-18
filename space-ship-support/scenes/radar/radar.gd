class_name Radar
extends Node2D

signal ship_lost
signal ship_fixed

@export var ship_scene: PackedScene
@export var window_scene: PackedScene
@export var window_root: Control
@export var ship_layout_generator: ShipLayoutGenerator

	# min difficulty: 0.0, max difficulty: 1.0
func spawn_ship(layout_difficulty: float = 0.0) -> void:
	var spawn_pos: Vector2 = Vector2(360, 0)
	spawn_pos = spawn_pos.rotated(randf() * PI * 2)
	var new_ship: Ship = ship_scene.instantiate()

	add_child(new_ship)
	new_ship.position = spawn_pos
	# rotate by -0.5 to 0.5 rad
	new_ship.ship_direction = (-spawn_pos).normalized().rotated(randf()-0.5)
	var ship_window: ShipWindow = window_scene.instantiate()
	# ship_window.hide()
	window_root.add_child(ship_window)
	new_ship.ship_window = ship_window
	
		
	var ship_layout_data: ShipLayoutData = ship_layout_generator.generate_layout_with_difficulty(layout_difficulty)
	new_ship.init_layout(ship_layout_data)
