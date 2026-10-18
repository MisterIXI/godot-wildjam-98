class_name ShipWindow
extends Panel

const SHIP_LAYOUT: PackedScene = preload("res://scenes/ship_spawner/ship_layout.tscn")

signal ship_strike
signal ship_failure
signal ship_success
signal ship_partial_success

@export var module_parent: Control

@export var integrity_color_on: Color
@export var integrity_color_off: Color
@export var integrity_leds: Array[TextureRect]
@export var description_label: RichTextLabel
var ship_radar_icon: Sprite2D

var integrity_left: int = 3
var ship_id:String = "SHIPID"
var title_mouse_down: bool = false
var is_dragging: bool = false
var mouse_pos_offset:= Vector2i.ZERO
var partial_drag: Vector2 = Vector2.ZERO

var is_collapsed: bool = false
var collapse_tween: Tween = null

var ship_layout_data: ShipLayoutData

var descriptions: Array[String]

## danger levels: 0=fixed, 1=warning, 2=critical
var danger_level: int = 0:
	set(val):
		danger_level = val
		_update_title()


@export var title_label: RichTextLabel
var mode_tween: Tween

func _ready() -> void:
	set_integrity(integrity_left)

func _update_title() -> void:
	match danger_level:
		1: #warning
			title_label.text = tr("ui.ship") + " #%s Status: [pulse][color=yellow]%s[/color][/pulse]" % [ship_id, tr("ui.status.warning")]
			warning_tween()
		2: # critical
			title_label.text = tr("ui.ship") + " #%s Status: [shake][color=red]%s[/color][/shake]" % [ship_id, tr("ui.status.critical")]
			alert_tween()
		_: # default
			title_label.text = tr("ui.ship") + " #%s Status: [color=green]%s[/color]" % [ship_id, tr("ui.status.normal")]
			clear_mode_tween()
			
func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if is_dragging:
				mouse_pos_offset = event.global_position - Vector2(position)
			else:
				if position.x < -size.x or \
					position.y < -$TitleBar.size.y or \
					position.x > get_viewport_rect().size.x or \
					position.y > get_viewport_rect().size.y:
						position = Vector2(500, 200)
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if collapse_tween:
				collapse_tween.kill()
			if is_collapsed:
				collapse_tween = create_tween()
				collapse_tween.tween_property(self, "size:y", 450., 0.1)
			else:
				collapse_tween = create_tween()
				collapse_tween.tween_property(self, "size:y", 30, 0.1)
			is_collapsed = not is_collapsed
	if event is InputEventMouseMotion:
		var mouse_motion:= event as InputEventMouseMotion
		if mouse_motion.button_mask  == MouseButtonMask.MOUSE_BUTTON_MASK_LEFT:
			var motion: Vector2 = mouse_motion.relative
			# print(mouse_motion.screen_velocity)
			# if mouse_motion.screen_velocity.x == 0:
			# 	motion.x = 0
			# if mouse_motion.screen_velocity.y == 0:
			# 	motion.y = 0
			position += motion

			# print(mouse_motion)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_parent().move_child(self,-1)
	
func init_ship_layout(ship_layout_data_new: ShipLayoutData) -> void:
	ship_layout_data = ship_layout_data_new
	var ship_layout: ShipLayout = SHIP_LAYOUT.instantiate() as ShipLayout
	ship_layout.init_from(ship_layout_data, ship_id)

	ship_layout.layout_strike.connect(_on_layout_strike)
	ship_layout.layout_success.connect(_on_layout_success)
	ship_layout.layout_partial_success.connect(_on_layout_partial_success)
	
	ship_layout.update_description.connect(_on_update_description)
	
	descriptions = ship_layout.puzzles[0].puzzle_config.descriptions
	module_parent.add_child(ship_layout)
	_on_update_description(0)

func set_integrity(integrity_left: int) -> void:
	for i in integrity_leds.size():
		set_led_active(i, i < integrity_left)

func set_led_active(index: int, led_active: bool) -> void:
	var led: TextureRect = integrity_leds[index]
	led.texture = ModDiagLed.LED_ON if led_active else ModDiagLed.LED_OFF
	led.modulate = integrity_color_on if led_active else integrity_color_off
	
func _on_layout_strike() -> void:
	if integrity_left == 0:
		return
		
	integrity_left -= 1
	set_integrity(integrity_left)
	
	ship_strike.emit()
	
	if (integrity_left == 0):
		AudioManager.play_sfx(AudioManagerClass.SfxType.UTIL_B)
		ship_failure.emit()
	else:
		AudioManager.play_sfx(AudioManagerClass.SfxType.CANCEL)

	
func _on_layout_partial_success() -> void:
	print("module: partial success")
	AudioManager.play_sfx(AudioManagerClass.SfxType.ACCEPT)
	ship_partial_success.emit()

func _on_layout_success() -> void:
	print("module: full success -> all puzzles solved")
	AudioManager.play_sfx(AudioManagerClass.SfxType.UTIL_A)
	ship_success.emit()
	danger_level = 0

func clear_mode_tween() -> void:
	if mode_tween:
		mode_tween.kill()
	mode_tween = create_tween()
	mode_tween.tween_property(self, "modulate", Color.WHITE, 2)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color.WHITE, 2)

func warning_tween()-> void:
	if mode_tween:
		mode_tween.kill()
	mode_tween = create_tween()
	mode_tween.set_loops()
	mode_tween.tween_property(self,"modulate",Color(1,1,0.5,1.0),2)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color(1,1,0.5,1.0),2)
	mode_tween.tween_property(self,"modulate",Color.WHITE,2)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color.WHITE,2)

func alert_tween()->void:
	if mode_tween:
		mode_tween.kill()
	mode_tween = create_tween()
	mode_tween.set_loops()
	mode_tween.tween_property(self,"modulate",Color(1,0.5,0.5,1.0),1)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color(1,0.5,0.5,1.0),1)
	mode_tween.tween_property(self,"modulate",Color.WHITE,1)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color.WHITE,1)


func flash_window() -> void:
	var tween:= create_tween()
	tween.set_loops(5)
	tween.tween_property(self,"modulate",Color(0.5,0.5,0.5,1.0),0.5)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color(0.5,0.5,0.5,1.0),0.5)
	tween.tween_property(self,"modulate",Color.WHITE,0.5)
	mode_tween.parallel().tween_property(ship_radar_icon, "modulate", Color.WHITE,0.5)

func _on_update_description(description_index: int) -> void:
	if description_index >= descriptions.size():
		description_label.text = tr("descriptions.no_remaining")
		return
	
	description_label.text = tr(descriptions[description_index])
