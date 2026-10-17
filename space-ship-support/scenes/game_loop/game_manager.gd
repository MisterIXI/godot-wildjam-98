class_name GameManager
extends Node

const MISTAKES_TO_FAIL: int = 3
# stats
var ships_fixed: int = 0
var time_elapsed: float = 0.0
var mistakes: int = 0
var game_active: bool = true
var time_to_next_ship: float = 3.0

var radar
@export var settings: GameSettings

func _process(delta: float) -> void:
	time_elapsed += delta

func _physics_process(delta: float) -> void:
	time_to_next_ship -= delta
	if time_to_next_ship <= 0.0:
		spawn_ship()
		time_to_next_ship = settings.spawn_curve.sample(time_elapsed / settings.time_to_reach_max_dif) * settings.max_ship_per_sec

func trigger_mistake() -> void:
	mistakes += 1
	if mistakes >= MISTAKES_TO_FAIL:
		# game over
		print("Game over with final time: ", time_elapsed)
		#TODO: popup final screen
	#TODO: update mistake/strike visual on radar

func spawn_ship() -> void:
	pass

