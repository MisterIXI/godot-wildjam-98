class_name ShipLayoutData
extends Resource

const NO_SLOT: ModuleData = preload("res://resources/no_slot.tres")

#var slots: Array[ModuleSlot] # or Dictionary[ModuleSlot, Array[Vector2i]] - too nested for gdscript
var slots: Dictionary[Vector2i, SlotData]
var size_x: int
var size_y: int


func _init() -> void:
	pass
	
func init_layout(size_x_new: int, size_y_new: int) -> void:
	size_x = size_x_new
	size_y = size_y_new
	
	#var full_size: int = size_x * size_y
	slots = {}

	for yi in size_y_new:
		for xi in size_x_new:
			slots[Vector2i(xi, yi)] = SlotData.from(NO_SLOT)
	
func get_matching_slots_for_module(module_slot: ModuleData) -> Array[Vector2i]:
	return get_matching_slots(module_slot.required_relative_positions)
	
func get_matching_slots_for_puzzle(puzzle: PuzzleConfigData) -> Array[Vector2i]:
	var required_relative_slot_positions: Array[Vector2i] = []
	
	for module: ModuleData in puzzle.relative_module_positions.keys():
		
		var relative_pos: Vector2i = puzzle.relative_module_positions[module]
		
		for required_rel_position: Vector2i in module.required_relative_positions:
			required_relative_slot_positions.append(relative_pos + required_rel_position)

	return get_matching_slots(required_relative_slot_positions)
		
## Rotated modules/relative slots not supported currently	
func get_matching_slots(relative_slots: Array[Vector2i]) -> Array[Vector2i]:
	var free_slots: Array[Vector2i] = get_free_slots()
	
	var matching_slots: Array[Vector2i] = []

	# check all free slots
	for slot_possibility: Vector2i in free_slots:
		
		# check all required slots. i.e. if slots are only 1x1, the only required slot is Vector2i(0,0)
		# for a horizontal 2x1 slot, the required slots would be [Vector2i(0,0), Vector2i(1,0)]
		
		var does_match: bool = true
		for slot_position: Vector2i in relative_slots:
			if slot_position == Vector2i.ZERO:
				# this is the slot we began with which we already know is free. nothing to check here
				continue
			
			var target_pos: Vector2 = slot_possibility + slot_position
			if !_is_free_slot(target_pos):
				does_match = false
				break
				
		if does_match:
			matching_slots.append(slot_possibility)
			

	return matching_slots

func has_free_slots() -> bool:
	return get_free_slots().size() > 0

func get_free_slots() -> Array[Vector2i]:
	return slots.keys().filter(_is_free)
	
func _is_free_slot(coord: Vector2i) -> bool:
	return _is_allowed(coord) && _is_free(coord)
	
func _is_allowed(coord: Vector2i) -> bool:
	return slots.has(coord)

func _is_free(coord: Vector2i) -> bool:
	return slots[coord].module_data.module_type == ModuleData.ModuleType.NONE

func debug_print_slot_layout() -> void:

	var res: String = ""
	for yi in size_y:
		var line: String = "["
		for xi in size_x:
			var coord: Vector2i = Vector2(xi, yi)
			if !slots.has(coord):
				line += " "
			
			if slots.has(coord):
				line += slot_to_string(slots[coord].module_data, slots[coord].is_main_index)
								
			if xi < size_x -1:
				line += "|"
			
		res += line + "]\n"
			
	print("Slots: \n" + res + "\n")
	
static func slot_to_string(module: ModuleData, is_main_index: bool) -> String:
	match module.module_type:
		ModuleData.ModuleType.NONE: return "-" if is_main_index else "_"
		ModuleData.ModuleType.FILLER: return "F" if is_main_index else "f"
		ModuleData.ModuleType.ACTION: return "A" if is_main_index else "a"
		ModuleData.ModuleType.ANALYSIS: return "N" if is_main_index else "n"
		
	return "?"
