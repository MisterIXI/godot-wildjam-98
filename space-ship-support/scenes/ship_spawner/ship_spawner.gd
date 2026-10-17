class_name ShipSpawner
extends Node

const MIN_X_SIZE: int = 3
const MAX_X_SIZE: int = 6

const MIN_Y_SIZE: int = 3
const MAX_Y_SIZE: int = 8

const SHIP_LAYOUT: PackedScene = preload("res://scenes/ship_spawner/ship_layout.tscn")

@export var puzzle_configs: Array[PuzzleConfigData]
@export var available_fillers: Array[ModuleData]

func _ready() -> void:
	instantiate_ship(create_ship_layout())



func instantiate_ship(ship_data: ShipLayoutData) -> void:
	var ship_layout: ShipLayout = SHIP_LAYOUT.instantiate() as ShipLayout
	ship_layout.init_from(ship_data)
	add_child(ship_layout)

func create_ship_layout() -> ShipLayoutData:
	
	var size_x: int = MIN_X_SIZE
	var size_y: int = MIN_Y_SIZE
	var ship_layout: ShipLayoutData = ShipLayoutData.new()
	ship_layout.init_layout(size_x, size_y) 
	
	#var modules: Dictionary[Vector2i, ModuleData] = {}
	
	#var ship_module: ShipModule = ShipModule.new()
	#ship_module.init_from_resource()

	#var free_slots: Array[Vector2i] = []

	_fill_puzzle_configurations(ship_layout, 1)
	_fill_free_slots(ship_layout)
		
	return ship_layout

func _fill_puzzle_configurations(ship_layout: ShipLayoutData, max_num_puzzles: int) -> void:
	var unused_puzzle_configs: Array[PuzzleConfigData] = puzzle_configs.duplicate()
	
	var num_remaining_puzzles: int = max_num_puzzles
	
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
			_apply_module(ship_layout, filler, target_slot)
			print("applied Filler '", filler.module_name + "' to the ship layout at ", target_slot)
			ship_layout.debug_print_slot_layout()

func _apply_puzzle(ship_layout: ShipLayoutData, puzzle: PuzzleConfigData, target_pos: Vector2i) -> void:
	for module: ModuleData in puzzle.relative_module_positions:
		_apply_module(ship_layout, module, target_pos + puzzle.relative_module_positions[module])

func _apply_module(ship_layout: ShipLayoutData, module: ModuleData, target_pos: Vector2i) -> void:
	for req_rel_pos: Vector2i in module.required_relative_positions:
		var computed_pos: Vector2i = target_pos + req_rel_pos
		#assert(ship_layout._is_free_slot(computed_pos))
		ship_layout.slots[computed_pos] = ShipLayoutData.SlotData.from(module, req_rel_pos == Vector2i.ZERO)
