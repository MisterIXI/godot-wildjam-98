extends Node2D

const SHIP_LOAD = preload("res://scenes/radar/ship.tscn")

@export var ship_speed = 100
@export var offset = 1.5
@export var spawn_points: Array[Marker2D]

var random = RandomNumberGenerator.new()
var spawn = null

func _on_spawn_timer_timeout() -> void:

	var random_outcome = random.randf_range(0, 8)
	#random_outcome = 8
	#if random_outcome == 8:
		#random_outcome -= 0.1
	# spawn = spawn_points.pick_random()
	spawn = spawn_points[int(random_outcome)]

	
	var new_ship = SHIP_LOAD.instantiate()
	#new_ship.velocity.y = -3
	new_ship.ship_setup(random_outcome,ship_speed,offset)
	spawn.add_child(new_ship)
	pass
	
