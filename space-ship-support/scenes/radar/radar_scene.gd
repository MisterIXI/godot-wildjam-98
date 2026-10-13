extends Node2D

const SHIP_LOAD = preload("res://scenes/radar/ship.tscn")

@export var ship_speed = 0

var random = RandomNumberGenerator.new()
var spawn = null

func _ready() -> void:
	print("test")
	var random_outcome = random.randf_range(0, 8)
	print("test")
	print(str(random_outcome))
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
	
	
	spawn.add_child(new_ship)
	pass
	
