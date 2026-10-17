class_name DemoModule
extends ShipModule

@export var debug_color_tr: TextureRect
@export var background_tr: TextureRect
@export var debug_label: Label
@export var debug_solve_label: RichTextLabel
@export var demo_button: Button


func _ready() -> void:
	pass
	
func init_from_resource(module_slot: ModuleData, module_position_new: Vector2i) -> void:
	super(module_slot, module_position_new)
	name = name.replace("Demo", module_slot.module_name)
	_set_color(module_slot.debug_color)
	
	var module_size_x: int = 1
	var module_size_y: int = 1
	for rrp: Vector2i in module_slot.required_relative_positions:
		module_size_x = max(module_size_x, rrp.x)
		module_size_y = max(module_size_y, rrp.y)
		
	size = size * Vector2(module_size_x, module_size_y)
	#background_tr.size = size
	background_tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	#debug_color_tr.size = debug_color_tr.size * Vector2(module_size_x, module_size_y)
	#debug_color_tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	debug_label.visible = module_slot.module_type != ModuleData.ModuleType.ACTION
	
	demo_button.visible = module_slot.module_type == ModuleData.ModuleType.ACTION
	debug_solve_label.visible = module_slot.module_type == ModuleData.ModuleType.ANALYSIS

	debug_label.text = module_slot.module_name
	demo_button.text = module_slot.module_name
	
	debug_solve_label.text = "[color=red]unsolved[/color]"

func _set_color(color_new: Color) -> void:
	(debug_color_tr.texture as GradientTexture2D).gradient.colors = [color_new]

func update_state(is_solved: bool) -> void:
	debug_solve_label.text = "[color=green]solved[/color]" if is_solved else "[color=red]unsolved[/color]"

func _on_demo_button_pressed() -> void:
	for pslot: ShipModule in puzzle_slots.values():
		(pslot as DemoModule).update_state(true)
