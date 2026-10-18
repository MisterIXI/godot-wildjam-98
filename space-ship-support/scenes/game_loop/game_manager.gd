class_name GameManager
extends Node

const MISTAKES_TO_FAIL: int = 3
# stats
var ships_fixed: int = 0
var time_elapsed: float = 0.0
var mistakes: int = 0
var game_active: bool = true
var time_to_next_ship: float = 3.0

@export var settings: GameSettings
@export var radar: Radar
@export var ui_canvas: CanvasLayer
@export var game_over_scene:PackedScene
@export var radar_interface: RadarInterface

func _ready() -> void:
	radar.ship_lost.connect(on_ship_lost)
	radar.ship_fixed.connect(on_ship_fixed)

func _process(delta: float) -> void:
	time_elapsed += delta
	radar_interface.score_label.text= "Ships Fixed: %d\nTime Elapsed: %d sec" % [ships_fixed, int(time_elapsed)]

func _physics_process(delta: float) -> void:
	time_to_next_ship -= delta
	if time_to_next_ship <= 0.0:
		spawn_ship()
		time_to_next_ship = settings.spawn_curve.sample(time_elapsed / settings.time_to_reach_max_dif) + ((randf() - 0.5) * settings.max_variance)
		print("time to next ship: ", time_to_next_ship)

func on_ship_lost() -> void:
	mistakes += 1
	radar_interface.strike_texs[mistakes-1].modulate = Color.RED
	if mistakes >= MISTAKES_TO_FAIL:
		# game over
		print("Game over with final time: ", time_elapsed)
		var end_screen:GameOver = game_over_scene.instantiate()
		ui_canvas.add_child(end_screen)
		end_screen.active(time_elapsed,ships_fixed,mistakes)
	#TODO: update mistake/strike visual on radar

func on_ship_fixed() -> void:
	ships_fixed += 1

func spawn_ship() -> void:
	radar.spawn_ship()

func get_max_ship_speed_bonus() -> float:
	return settings.ship_speed_max_bonus.sample(time_elapsed / settings.time_to_reach_max_dif)
