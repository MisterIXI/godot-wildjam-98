
class_name SlotData
extends RefCounted

var module_data: ModuleData
var is_main_index: bool
var puzzle_data: PuzzleConfigData = null

static func from(module: ModuleData, is_main_index_new: bool = true, puzzle_config_data: PuzzleConfigData = null) -> SlotData:
	
	var res: SlotData = SlotData.new()
	res.module_data = module
	res.is_main_index = is_main_index_new
	res.puzzle_data = puzzle_config_data
	return res
		

static func is_main_pos(pos: Vector2i) -> bool:
	return pos == Vector2i(0,0)
