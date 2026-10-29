class_name PuzzleConfigData
extends Resource

## A combination of multiple modules that form a puzzle/problem case
## The dictionary contains all necessary modules and their relative positions that make up the puzzle
## SHOULD ALWAYS CONTAIN Vector2i(0,0) (aka Vector2i.ZERO)
@export var relative_module_positions: Dictionary[ModuleData, Vector2i]

## Probably only used for debug
@export var puzzle_name: String = ""

@export var analysis_code: Array[String] = []

@export var module_name_interaction_sequence: Array[String]

@export var descriptions: Array[String]
