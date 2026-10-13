class_name Settings
extends VBoxContainer

@export var overall_volume_h_slider: HSlider
@export var music_volume_h_slider: HSlider
@export var sfx_volume_h_slider: HSlider

@export var overall_volume_value_label: Label
@export var music_volume_value_label: Label
@export var sfx_volume_value_label: Label

@export var locale_option_button: OptionButton
@export var fullscreen_check_button: CheckButton

var fullscreen_active: bool

func _ready() -> void:
	load_values_from_settings()
	
func load_values_from_settings() -> void:
	overall_volume_h_slider.set_value_no_signal(SettingsIO.master_volume_linear)
	music_volume_h_slider.set_value_no_signal(SettingsIO.music_volume_linear)
	sfx_volume_h_slider.set_value_no_signal(SettingsIO.sfx_volume_linear)
	
	set_percent_slider_value(overall_volume_value_label, SettingsIO.master_volume_linear)
	set_percent_slider_value(music_volume_value_label, SettingsIO.music_volume_linear)
	set_percent_slider_value(sfx_volume_value_label, SettingsIO.sfx_volume_linear)
	
	set_fullscreen_active(SettingsIO.fullscreen_active)

	locale_option_button.selected = get_locale_button_id(SettingsIO.locale)

func set_percent_slider_value(label: Label, value_linear: float) -> void:
	label.text = str(roundi(value_linear * 100)) + "%"

static func get_locale_button_id(locale_item: SettingsIOClass.LocaleItem) -> int:
	match locale_item:
		SettingsIOClass.LocaleItem.EN: return 0
		SettingsIOClass.LocaleItem.DE: return 1

	return 0
	
static func get_languagecode_from_uitext(locale_str: String) -> String:
	if locale_str == "Deutsch":
		return "de";
	else:
		return "en";
		
static func get_locale_item_from_uitext(locale_str: String) -> SettingsIOClass.LocaleItem:
	if locale_str.to_lower().contains("deutsch"):
		return SettingsIOClass.LocaleItem.DE;
	else:
		return SettingsIOClass.LocaleItem.EN;

func set_fullscreen_active(is_active_new: bool) -> void:
	fullscreen_active = is_active_new
	SettingsIOClass.set_fullscreen(is_active_new)
	SettingsIO.set_fullscreen_active(is_active_new, true)
	fullscreen_check_button.set_pressed_no_signal(fullscreen_active)
	
func _on_skip_intro_check_button_toggled(toggled_on: bool) -> void:
	SettingsIO.set_skip_intro_active(toggled_on)

func _on_overall_volume_h_slider_value_changed(value: float) -> void:
	#play hover sfx
	SettingsIO.set_master_volume(value, false)
	set_percent_slider_value(overall_volume_value_label, value)
	Utils.set_bus_volume(SettingsIOClass.AudioType.MASTER, value)	

func _on_music_volume_h_slider_value_changed(value: float) -> void:
	#play hover sfx
	SettingsIO.set_music_volume(value, false)
	set_percent_slider_value(music_volume_value_label, value)
	Utils.set_bus_volume(SettingsIOClass.AudioType.MUSIC, value)

func _on_sfx_volume_h_slider_value_changed(value: float) -> void:
	#play hover sfx
	SettingsIO.set_sfx_volume(value, false)
	set_percent_slider_value(sfx_volume_value_label, value)
	Utils.set_bus_volume(SettingsIOClass.AudioType.SFX, value)

func _on_overall_volume_h_slider_drag_ended(value_changed: bool) -> void:
	#play accept sfx
	if value_changed:
		SettingsIO.set_master_volume(overall_volume_h_slider.value)
		
func _on_music_volume_h_slider_drag_ended(value_changed: bool) -> void:
	#play accept sfx
	if value_changed:
		SettingsIO.set_music_volume(music_volume_h_slider.value)
		
func _on_sfx_volume_h_slider_drag_ended(value_changed: bool) -> void:
	#play accept sfx
	if value_changed:
		SettingsIO.set_sfx_volume(sfx_volume_h_slider.value)
#func on_release_slider(_value_changed: bool) -> void:
	#SettingsIO.save_to_file()
	
func _on_fullscreen_check_button_toggled(toggled_on: bool) -> void:
	#play accept sfx
	set_fullscreen_active(toggled_on)

func _on_locale_option_button_item_selected(index: int) -> void:
	#play accept sfx
	var locale_new: String = locale_option_button.get_item_text(index);
	TranslationServer.set_locale(get_languagecode_from_uitext(locale_new))
	SettingsIO.set_locale(get_locale_item_from_uitext(locale_new))
