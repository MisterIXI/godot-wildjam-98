class_name RemoteControlModule
extends ShipModule

@export var target_module_name: String
var target_modules: Array[ShipModule]

## called when all relevant data (module data, puzzle slots) is linked
func _on_init_finished() -> void:
	
	## searches the slots linked with the puzzle for the provided target_module_name
	target_modules.assign(linked_puzzle_slots.values().filter(has_matching_name.bind(target_module_name)))
	
func has_matching_name(module: ShipModule, target_name: String) -> bool:
	return module.module_data.module_name == target_name


func _on_check_button_toggled(toggled_on: bool) -> void:
	use_module(true)
	
	for module: ShipModule in target_modules:
		if module.has_method("toggle_lock"):
			@warning_ignore("unsafe_method_access")
			module.toggle_lock(toggled_on)
		else:
			push_warning("the target module for remote control (", module, ") does not have a function 'toggle_lock'")
