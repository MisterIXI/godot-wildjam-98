class_name ShipModule
extends Control

var module_position: Vector2i

var puzzle_slots: Dictionary[Vector2i, ShipModule] = {}

func init_from_resource(_module_slot: ModuleData, module_position_new: Vector2i) -> void:
	module_position = module_position_new
	#print("ship module init: ", module_slot.module_name)
	pass
	
func link_puzzle_slots(puzzle_slots_new: Dictionary[Vector2i, ShipModule]) -> void:
	puzzle_slots = puzzle_slots_new
