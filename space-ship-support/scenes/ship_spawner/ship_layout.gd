class_name ShipLayout
extends Control

signal update_description(idx_new: int)
signal layout_strike
signal layout_success
signal layout_partial_success

const SLOT_SIZE_XY: float = 100

@export var start_marker: Marker2D

var modules: Dictionary[Vector2i, ShipModule] = {}

var num_puzzles_solved: int = 0

var puzzles: Array[Puzzle] = []

func _ready() -> void:
	pass

func init_from(layout_data: ShipLayoutData, ship_id: String) -> void:
	num_puzzles_solved = 0
	puzzles = []
	
	var puzzle_modules: Dictionary[ShipModule, PuzzleConfigData] = {}
	
	for slot_position: Vector2i in layout_data.slots.keys():
		var slot_data: SlotData = layout_data.slots[slot_position]
		if !slot_data.is_main_index:
			continue
		var module_data: ModuleData = slot_data.module_data
				
		var scene: PackedScene = module_data.get_or_load_scene()

		var module: ShipModule = scene.instantiate() as ShipModule
		module.set_ship_id(ship_id)
		module.position = get_spawn_pos(slot_position)
		module.init_from_resource(module_data, slot_position)
		add_child(module)
		#print("slot: ", slot_position, " -> init module:" , module_data.module_name, " with color ", module_data.debug_color.to_html())
		modules[slot_position] = module
		
		module.module_used.connect(_on_module_used)
		
		if slot_data.puzzle_data != null:
			puzzle_modules[module] = slot_data.puzzle_data
			
	for main_puzzle_module: ShipModule in puzzle_modules.keys():
		var puzzle: Puzzle = Puzzle.new()
		puzzle.init(puzzle_modules[main_puzzle_module])
		var puzzle_index = puzzles.size()
		link_puzzle_data(main_puzzle_module, puzzle_modules[main_puzzle_module], puzzle_index)
		puzzles.append(puzzle)
		
func get_spawn_pos(vec2i: Vector2i) -> Vector2:
	return (vec2i * SLOT_SIZE_XY)

func link_puzzle_data(main_puzzle_module: ShipModule, puzzle: PuzzleConfigData, puzzle_index: int) -> void:
	
	var linked_modules: Dictionary[Vector2i, ShipModule] = {}
	
	var start_position: Vector2i = main_puzzle_module.module_position
	
	for module_data: ModuleData in puzzle.relative_module_positions.keys():
		var relative_position: Vector2i = puzzle.relative_module_positions[module_data]
		
		var abs_position: Vector2i = start_position + relative_position
		linked_modules[abs_position] = modules[abs_position]
	
	for module_position: Vector2i in linked_modules:
		var other_linked_modules: Dictionary = linked_modules.duplicate()
		other_linked_modules.erase(module_position)
		
		linked_modules[module_position].link_puzzle_slots(other_linked_modules)
		
		linked_modules[module_position].set_puzzle_code(puzzle.analysis_code)
		linked_modules[module_position].set_puzzle_index(puzzle_index)


static func is_action_module(module_data: ModuleData) -> bool:
	return module_data.module_type == ModuleData.ModuleType.ACTION
	
static func is_analysis_module(module_data: ModuleData) -> bool:
	return module_data.module_type == ModuleData.ModuleType.ANALYSIS

func _on_module_used(module_name: String, puzzle_idx: int) -> void:	
	if puzzle_idx < 0:
		_on_module_strike()
		return
		
	var puzzle: Puzzle = puzzles[puzzle_idx]
	
	if puzzle.is_finished():
		_on_module_strike()
		return
				
	var use_result: bool = puzzle.use_module(module_name)
	
	if !use_result:
		_on_module_strike()
		return
	
	update_description.emit(puzzle.current_progress_index)
	
	if puzzle.is_finished():
		
		num_puzzles_solved += 1
		if num_puzzles_solved == puzzles.size():
			_on_module_success()
		
	else:
		_on_module_partial_success()

func _on_module_strike() -> void:
	layout_strike.emit()

func _on_module_partial_success() -> void:
	layout_partial_success.emit()
	
func _on_module_success() -> void:
	layout_success.emit()	
