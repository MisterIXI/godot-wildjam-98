class_name LockedActionModule
extends ShipModule

@export var button: Button

func toggle_lock(toggled: bool) -> void:
	button.disabled = !toggled
