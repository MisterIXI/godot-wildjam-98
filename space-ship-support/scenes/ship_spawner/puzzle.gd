class_name Puzzle
extends RefCounted

var puzzle_sequence: Array[String]
var current_progress_index: int = 0

func init(puzzle_config: PuzzleConfigData) -> void:
	puzzle_sequence = puzzle_config.module_name_interaction_sequence
	current_progress_index = 0	
	
	
func use_module(module_name: String) -> bool:
	if module_name.strip_edges().to_lower() == puzzle_sequence[current_progress_index].strip_edges().to_lower():
		current_progress_index += 1
		return true
		
	return false
	
func is_finished() -> bool:
	return current_progress_index >= puzzle_sequence.size()
