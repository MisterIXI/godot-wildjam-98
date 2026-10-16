class_name DemoModule
extends ShipModule

@export var sprite_2d: Sprite2D
@export var debug_label: Label


func _ready() -> void:
	pass
	
func init_from_resource(module_slot: ModuleData) -> void:
	super(module_slot)
	name = name.replace("Demo", module_slot.module_name)
	_set_color(module_slot.debug_color)
	debug_label.text = module_slot.module_name

func _set_color(color_new: Color) -> void:
	(sprite_2d.texture as GradientTexture2D).gradient.colors = [color_new]
