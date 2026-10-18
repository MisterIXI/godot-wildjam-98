class_name ShipSpawner
extends Node

const SHIP_LAYOUT: PackedScene = preload("res://scenes/ship_spawner/ship_layout.tscn")

@export_range(2, 30) var min_x_size: int = 4
@export_range(2, 30) var max_x_size: int = 4

@export_range(2, 30) var min_y_size: int = 4
@export_range(2, 30) var max_y_size: int = 4
 
@export_range(2, 30) var min_num_puzzles: int = 1
@export_range(2, 30) var max_num_puzzles: int = 3

@export_range(0.0, 0.9) var difficulty_variance: float = 0.1


@export var puzzle_configs: Array[PuzzleConfigData]
@export var available_fillers: Array[ModuleData]

func _ready() -> void:
	assert(puzzle_configs.size() >= 1)
	assert(available_fillers.size() >= 1)

#region test ship spawn. may be deleted
	# TODO: delete, this is just for testing

	test_spawn_ship()

func test_spawn_ship() -> void:
	var difficulty: float = 0.0
	var ship_layout: ShipLayoutData = create_ship_layout_with_difficulty(difficulty)
	
	instantiate_ship(ship_layout)

#endregion

func create_ship_layout_with_difficulty(difficulty: float) -> ShipLayoutData:
	var used_difficulty: float = clamp(randf_range(difficulty-difficulty_variance, difficulty+difficulty_variance), 0.0, 1.0)
	
	var size_x: int = roundi(lerpf(min_x_size, max_x_size, used_difficulty))
	var size_y: int = roundi(lerpf(min_y_size, max_y_size, used_difficulty))
	var num_puzzles: int = roundi(lerpf(min_num_puzzles, max_num_puzzles, used_difficulty))
	return create_ship_layout(size_x, size_y, num_puzzles)
	
func instantiate_ship(ship_data: ShipLayoutData) -> void:
	var ship_layout: ShipLayout = SHIP_LAYOUT.instantiate() as ShipLayout
	ship_layout.init_from(ship_data)
	add_child(ship_layout)

func create_ship_layout(size_x: int, size_y: int, num_puzzles: int) -> ShipLayoutData:
	print("creating ship layout with ", size_x, " x ", size_y, " and ", num_puzzles, " puzzles")
	var puzzle_size_heuristic: int = 3
	var warn_threshold: float = 0.75
	var num_slots: int = size_x * size_y
	if num_puzzles * puzzle_size_heuristic > warn_threshold * (num_slots as float):
		var warning: String = "the number of puzzles (%s) may be too big for this layout (%sx%s = %s). " % [num_puzzles, size_x, size_y, size_x*size_y]
		warning += "Used heuristic: %sx%s = %s > %s = %sx%s" % [num_puzzles, puzzle_size_heuristic, num_puzzles*puzzle_size_heuristic, warn_threshold * (num_slots as float), warn_threshold, num_slots]
		push_warning(warning)
	
	var ship_layout: ShipLayoutData = ShipLayoutData.new()
	ship_layout.init_layout(size_x, size_y) 
	
	_fill_puzzle_configurations(ship_layout, num_puzzles)
	_fill_free_slots(ship_layout)
		
	return ship_layout

func _fill_puzzle_configurations(ship_layout: ShipLayoutData, target_num_puzzles: int) -> void:
	var unused_puzzle_configs: Array[PuzzleConfigData] = puzzle_configs.duplicate()
	
	var num_remaining_puzzles: int = target_num_puzzles
	
	for i in num_remaining_puzzles:
		
		# pick random puzzle
		var found_config: bool = false
		while(!found_config && unused_puzzle_configs.size() > 0):
			var possible_puzzle: PuzzleConfigData = unused_puzzle_configs.pop_at(randi_range(0, unused_puzzle_configs.size()-1))
		
			# test if all required slots match
			var matching_slots: Array[Vector2i] = ship_layout.get_matching_slots_for_puzzle(possible_puzzle)
		
			if matching_slots.size() > 0:
				
				found_config = true
				var target_slot: Vector2i = matching_slots.pick_random()
				_apply_puzzle(ship_layout, possible_puzzle, target_slot)
				print("applied Puzzle '", possible_puzzle.puzzle_name + "' to the ship layout at ", target_slot)
				ship_layout.debug_print_slot_layout()
				break

func _fill_free_slots(ship_layout: ShipLayoutData) -> void:
	var unused_fillers: Array[ModuleData] = available_fillers.duplicate()
	
	while ship_layout.has_free_slots():
		if unused_fillers.size() == 0:
			unused_fillers = available_fillers.duplicate()
		
		var filler: ModuleData = unused_fillers.pop_at(randi_range(0, unused_fillers.size()-1))
		var matching_slots: Array[Vector2i] = ship_layout.get_matching_slots_for_module(filler)
		if matching_slots.size() > 0:
			
			var target_slot: Vector2i = matching_slots.pick_random()
			_apply_module(ship_layout, null, filler, target_slot)
			print("applied Filler '", filler.module_name + "' to the ship layout at ", target_slot)
			ship_layout.debug_print_slot_layout()

func _apply_puzzle(ship_layout: ShipLayoutData, puzzle: PuzzleConfigData, target_pos: Vector2i) -> void:
	for module: ModuleData in puzzle.relative_module_positions:
		
		var relative_puzzle_pos: Vector2i = puzzle.relative_module_positions[module]
		
		# only the main slot of a puzzle needs to have puzzle data. This will be used in ship layout.
		var passed_puzzle_data: PuzzleConfigData = puzzle if SlotData.is_main_pos(relative_puzzle_pos) else null
			
		_apply_module(ship_layout, passed_puzzle_data, module, target_pos + relative_puzzle_pos)

func _apply_module(ship_layout: ShipLayoutData, puzzle_data: PuzzleConfigData, module: ModuleData, target_pos: Vector2i) -> void:
	var has_main_position: bool = false
	
	for req_rel_pos: Vector2i in module.required_relative_positions:
		var computed_pos: Vector2i = target_pos + req_rel_pos
		#assert(ship_layout._is_free_slot(computed_pos))
		var is_main_slot: bool = SlotData.is_main_pos(req_rel_pos)
		ship_layout.slots[computed_pos] = SlotData.from(module, is_main_slot, puzzle_data)
		if is_main_slot:
			has_main_position = true

	if !has_main_position:
		push_warning("module ", module.module_name, " has no main position, i.e. required_relative_positions does not contain a Vector2i(0,0). This may lead to errors")
