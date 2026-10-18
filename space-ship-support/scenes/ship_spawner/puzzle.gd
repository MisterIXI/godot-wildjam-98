class_name Puzzle
extends RefCounted

var puzzle_sequence: Array[String]
var current_progress_index: int = 0
var puzzle_config: PuzzleConfigData


func init(puzzle_config_new: PuzzleConfigData) -> void:
	if puzzle_config_new == null:
		return
	current_progress_index = 0	
	puzzle_config = puzzle_config_new
	puzzle_sequence = puzzle_config_new.module_name_interaction_sequence

func use_module(module_name: String) -> bool:
	if module_name.strip_edges().to_lower() == puzzle_sequence[current_progress_index].strip_edges().to_lower():
		current_progress_index += 1
		return true
		
	return false
	
func is_finished() -> bool:
	return current_progress_index >= puzzle_sequence.size()
