class_name Radar
extends Node2D

signal ship_lost
signal ship_fixed
const RADIUS:float = 360.
const DIAMETER:float = 720
@export var ship_scene: PackedScene
@export var window_scene: PackedScene
@export var window_root: Control
@export var radar_interface: RadarInterface
var current_ids:Array[int] = []
@export var ship_layout_generator: ShipLayoutGenerator
@export var game_manager: GameManager

# min difficulty: 0.0, max difficulty: 1.0
func spawn_ship(layout_difficulty: float = 0.0) -> void:
	var spawn_pos: Vector2 = Vector2(RADIUS, 0)
	spawn_pos = spawn_pos.rotated(randf() * PI * 2)
	var new_ship: Ship = ship_scene.instantiate()

	add_child(new_ship)
	new_ship.destroyed.connect(on_ship_destroyed)
	new_ship.position = spawn_pos
	var new_id = randi_range(10000,99999)
	while current_ids.has(new_id):
		new_id = randi_range(10000,99999)
	current_ids.append(new_id)
	new_ship.ship_id = str(new_id)
	new_ship.ship_speed = 12.0 + randf() * game_manager.get_max_ship_speed_bonus()
	# rotate by -0.5 to 0.5 rad
	new_ship.ship_direction = (-spawn_pos).normalized().rotated(randf()-0.5)
	var ship_window: ShipWindow = window_scene.instantiate()
	ship_window.ship_id = new_ship.ship_id
	ship_window._update_title()
	ship_window.hide()
	window_root.add_child(ship_window)
	new_ship.ship_window = ship_window
	radar_interface.add_message("Ship detected at: %s | ID: %s" % [str(spawn_pos), new_ship.ship_id])
	# ship timing message
	var vel_message_delay: float = randf() * 3.5 + 2.5
	var ship_estimate: float = DIAMETER / new_ship.ship_speed - vel_message_delay
	if ship_estimate > 0.5:
		var tween = new_ship.create_tween()
		tween.tween_interval(vel_message_delay)
		tween.tween_callback(
			radar_interface.add_message.bind("Ship $%s estimated travel time: %d" % [new_ship.ship_id, ship_estimate])
		)
		
	var ship_layout_data: ShipLayoutData = ship_layout_generator.generate_layout_with_difficulty(layout_difficulty)
	new_ship.init_layout(ship_layout_data)

func on_ship_destroyed(ship: Ship, was_fixed: bool) ->  void:
	if was_fixed:
		radar_interface.add_message("Ship $%s left comms range and was fixed." % [ship.ship_id])
		ship_fixed.emit()
	else:
		radar_interface.add_message("Signal to Ship $%s lost. Not all issues fixed. Penalty applied." % [ship.ship_id])
		ship_lost.emit()
	current_ids.erase(ship.ship_id)