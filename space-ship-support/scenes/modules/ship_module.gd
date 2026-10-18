class_name ShipModule
extends Control


signal module_used(module_name: String, puzzle_idx: int)

var module_position: Vector2i
var module_data: ModuleData
var linked_puzzle_slots: Dictionary[Vector2i, ShipModule] = {}
var puzzle_code: Array[String] = []
var puzzle_index: int = -1
var ship_id: String

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

func use_module(is_correct: bool) -> void:
	if !is_correct:
		module_used.emit("", -1) # does not match any
		
	if is_correct:
		module_used.emit(module_data.module_name, puzzle_index)

func set_ship_id(id_new: String) -> void:
	ship_id = id_new
