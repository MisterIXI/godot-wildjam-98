class_name ShipModule
extends Node2D

func init_from_resource(module_slot: ModuleData) -> void:
	print("ship module init: ", module_slot.module_name)
