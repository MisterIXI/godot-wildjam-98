class_name ModuleData
extends Resource

## A single module slot that can be instantiated


enum ModuleType {
	NONE, # only used during creation
	FILLER, # Modules that are meaningless / flavor / empty
	ACTION, # Modules 
	ANALYSIS
}


## The scene that is used to represent this module. This will be instantiated
@export_file("*.tscn") var target_scene_path: String

## Can be used if we want a module to have different dimensions
## e.g. a 1x2 module could be [Vector2i(0,0), Vector2i(0,1)] 
## SHOULD ALWAYS CONTAIN Vector2i(0,0) (aka Vector2i.ZERO)
@export var required_relative_positions: Array[Vector2i] = [Vector2i(0,0)]

## The type of module. None means no module is assigned here. This is used
## during spawn. We may not actually need the distinction between the other cases (filler, action, analysis)
@export var module_type: ModuleType

## The name of the module. probably only for debug purposes
@export var module_name: String

@export var debug_color: Color

var cached_scene: PackedScene = null

func get_or_load_scene() -> PackedScene:
	if cached_scene == null:
		cached_scene = load(target_scene_path)
	
	return cached_scene
