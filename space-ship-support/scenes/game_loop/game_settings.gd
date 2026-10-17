class_name GameSettings
extends Resource

@export var spawn_curve: Curve
@export var time_to_reach_max_dif: float = 300.0
@export_range(0.01, 1.0) var max_ship_per_sec: float = 0.6