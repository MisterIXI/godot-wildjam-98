class_name ShipLayout
extends Node2D

const SLOT_SIZE_XY: float = 80

@export var start_marker: Marker2D

func _ready() -> void:
	pass

func init_from(layout_data: ShipLayoutData) -> void:
	
	for slot_position: Vector2i in layout_data.slots.keys():
		var slot_data: ShipLayoutData.SlotData = layout_data.slots[slot_position]
		if !slot_data.is_main_index:
			continue
		var module_data: ModuleData = slot_data.module_data
		
		var scene: PackedScene = module_data.get_or_load_scene()

		var module: ShipModule = scene.instantiate() as ShipModule
		module.global_position = get_spawn_pos(slot_position)
		module.init_from_resource(module_data)
		add_child(module)
		print("slot: ", slot_position, " -> init module:" , module_data.module_name, " with color ", module_data.debug_color.to_html())
		
func get_spawn_pos(vec2i: Vector2i) -> Vector2:
	return start_marker.global_position + (vec2i * SLOT_SIZE_XY)
