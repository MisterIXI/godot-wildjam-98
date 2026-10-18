class_name Radar
extends Node2D

signal ship_lost
signal ship_fixed

@export var ship_scene: PackedScene

var ship_data: Dictionary[Ship, Window] = {}

func spawn_ship() -> void:
	var spawn_pos: Vector2 = Vector2(360, 0)
	spawn_pos = spawn_pos.rotated(randf() * PI * 2)
	var new_ship: Ship = ship_scene.instantiate()
	add_child(new_ship)
	new_ship.position = spawn_pos
	# rotate by -0.5 to 0.5 rad
	new_ship.ship_direction = (-spawn_pos).normalized().rotated(randf()-0.5)
	
