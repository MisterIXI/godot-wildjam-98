extends Node

var current_score: int = 0

func add_to_score(amount: int) -> void:
	current_score += amount
	
func reset_score() -> void:
	current_score = 0
