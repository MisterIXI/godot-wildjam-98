class_name ShipModule
extends Control


signal module_used(module_name: String, puzzle_idx: int)

var module_position: Vector2i
var module_data: ModuleData
var linked_puzzle_slots: Dictionary[Vector2i, ShipModule] = {}
var puzzle_code: Array[String] = []
var puzzle_index: int = -1

func init_from_resource(module_data_new: ModuleData, module_position_new: Vector2i) -> void:
	module_position = module_position_new
	module_data = module_data_new
	#print("ship module init: ", module_slot.module_name)
	
func link_puzzle_slots(puzzle_slots_new: Dictionary[Vector2i, ShipModule]) -> void:
	linked_puzzle_slots = puzzle_slots_new

func set_puzzle_code(puzzle_code_new: Array[String]) -> void:
	puzzle_code = puzzle_code_new
	_on_init_finished()
	
func set_puzzle_index(puzzle_index_new: int) -> void:
	puzzle_index = puzzle_index_new

## called when all relevant data (module data, puzzle slots) is linked
func _on_init_finished() -> void:
	pass
