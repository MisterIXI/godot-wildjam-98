class_name PuzzleConfigData
extends Resource

## A combination of multiple modules that form a puzzle/problem case
## The dictionary contains all necessary modules and their relative positions that make up the puzzle

@export var relative_module_positions: Dictionary[ModuleData, Vector2i]

## Probably only used for debug
@export var puzzle_name: String = ""
