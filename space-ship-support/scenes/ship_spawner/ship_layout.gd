class_name ShipLayout
extends Control


const SLOT_SIZE_XY: float = 100

@export var start_marker: Marker2D

var modules: Dictionary[Vector2i, ShipModule] = {}

func _ready() -> void:
	pass

func init_from(layout_data: ShipLayoutData) -> void:

	var puzzle_modules: Dictionary[ShipModule, PuzzleConfigData] = {}
	
	for slot_position: Vector2i in layout_data.slots.keys():
		var slot_data: SlotData = layout_data.slots[slot_position]
		if !slot_data.is_main_index:
			continue
		var module_data: ModuleData = slot_data.module_data
				
		var scene: PackedScene = module_data.get_or_load_scene()

		var module: ShipModule = scene.instantiate() as ShipModule
		module.position = get_spawn_pos(slot_position)
		module.init_from_resource(module_data, slot_position)
		add_child(module)
		print("slot: ", slot_position, " -> init module:" , module_data.module_name, " with color ", module_data.debug_color.to_html())
		modules[slot_position] = module
		
		
		if slot_data.puzzle_data != null:
			puzzle_modules[module] = slot_data.puzzle_data
			
	for main_puzzle_module: ShipModule in puzzle_modules.keys():
		link_puzzle_data(main_puzzle_module, puzzle_modules[main_puzzle_module])
		
func get_spawn_pos(vec2i: Vector2i) -> Vector2:
	return (vec2i * SLOT_SIZE_XY)

func link_puzzle_data(main_puzzle_module: ShipModule, puzzle: PuzzleConfigData) -> void:
	
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

static func is_action_module(module_data: ModuleData) -> bool:
	return module_data.module_type == ModuleData.ModuleType.ACTION
	
static func is_analysis_module(module_data: ModuleData) -> bool:
	return module_data.module_type == ModuleData.ModuleType.ANALYSIS
