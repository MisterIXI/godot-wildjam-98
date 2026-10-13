extends Node2D

const SHIP_LOAD = preload("res://scenes/radar/ship.tscn")

@export var ship_speed = 200
@export var offset = 1.5

var random = RandomNumberGenerator.new()
var spawn = null

func _on_spawn_timer_timeout() -> void:

	var random_outcome = random.randf_range(0, 8)

	if random_outcome < 1:
		spawn = $SpawnPoint1
	elif random_outcome < 2:
		spawn = $SpawnPoint2
	elif random_outcome < 3:
		spawn = $SpawnPoint3
	elif random_outcome < 4:
		spawn = $SpawnPoint4
	elif random_outcome < 5:
		spawn = $SpawnPoint5
	elif random_outcome < 6:
		spawn = $SpawnPoint6
	elif random_outcome < 7:
		spawn = $SpawnPoint7
	elif random_outcome < 8:
		spawn = $SpawnPoint8
	var new_ship = SHIP_LOAD.instantiate()
	#new_ship.velocity.y = -3
	new_ship.ship_setup(random_outcome,ship_speed,offset)
	spawn.add_child(new_ship)
	pass
	
