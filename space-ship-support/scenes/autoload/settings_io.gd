## Autoload: SettingsIO
class_name SettingsIOClass # to allow for typed access
extends Node

enum LocaleItem {
	EN, 
	DE	
}

enum AudioType
{
	MASTER,
	MUSIC,
	SFX,
	AMBIENCE
}

signal locale_changed

const SETTINGS_PATH: String = "user://settings.save"
const FULLSCREEN_IS_BORDERLESS: bool = true

var master_volume_linear: float = 0.75
var master_volume_muted: bool = false
var music_volume_linear: float = 1
var music_volume_muted: bool = false
var sfx_volume_linear: float = 1
var sfx_volume_muted: bool = false
var ambience_volume_linear: float = 1
var ambience_volume_muted: float = 1

var locale: LocaleItem = LocaleItem.EN

var mouse_sensitivity: float = 0.5
var gamepad_stick_sensitivity: float = 0.5

var fullscreen_active: bool = false

var input_remaps: Dictionary[String, Dictionary] = {} #nested array is Dictionary[int, InputEvent]

var player_names: Array[String] = []
var use_online_features: bool = true

var skip_intro_active: bool = false

func _ready() -> void:
	if is_web_build():
		apply_web_build_settings()
	
	load_from_file()
	apply_values()
	
func apply_values() -> void:
	Utils.set_bus_volume(AudioType.MASTER, master_volume_linear)
	Utils.set_bus_volume(AudioType.MUSIC, music_volume_linear)
	Utils.set_bus_volume(AudioType.SFX, sfx_volume_linear)
	#Utils.set_bus_volume(AudioType.AMBIENCE, ambience_volume_linear)
	Utils.set_bus_muted(AudioType.MASTER, master_volume_muted)
	Utils.set_bus_muted(AudioType.MUSIC, music_volume_muted)
	Utils.set_bus_muted(AudioType.SFX, sfx_volume_muted)
	#Utils.set_bus_muted(AudioType.AMBIENCE, ambience_volume_muted)
	
	TranslationServer.set_locale(to_short_locale(locale))
	set_fullscreen(fullscreen_active)

func apply_web_build_settings() -> void:
	pass

func reset(do_save: bool = true) -> void:
	set_skip_intro_active(false, false)
	
	set_master_volume(0.75, false)
	set_music_volume(1, false)
	set_sfx_volume(1, false)
	set_ambience_volume(1, false)
	set_master_volume_muted(false, false)
	set_music_volume_muted(false, false)
	set_sfx_volume_muted(false, false)
	set_ambience_volume_muted(false, false)

	set_locale(LocaleItem.EN, false)
	set_fullscreen_active(false, false)
	
	if do_save:
		save_to_file()

func save_to_file() -> void:
	var settings_file_access: FileAccess = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	var save_dict: Dictionary = {
		"master_volume_linear": master_volume_linear,
		"music_volume_linear": music_volume_linear,
		"sfx_volume_linear": sfx_volume_linear,
		"ambience_volume_linear": ambience_volume_linear,
		"master_volume_muted": master_volume_muted,
		"music_volume_muted": music_volume_muted,
		"sfx_volume_muted": sfx_volume_muted,
		"ambience_volume_muted": ambience_volume_muted,
		"locale": locale,
		"fullscreen_active": fullscreen_active,
		"mouse_sensitivity": mouse_sensitivity,
		"gamepad_stick_sensitivity": gamepad_stick_sensitivity,
		"skip_intro_active": skip_intro_active,
		"player_names": var_to_str(player_names),
		"use_online_features": use_online_features,
	}
	
	var json_string: String = JSON.stringify(save_dict)
	settings_file_access.store_line(json_string)
	
func load_from_file() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return # We don't have a file to load.

	var save_game: FileAccess = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string: String = save_game.get_line()
		var json: JSON = JSON.new()
		var parseResult: Error = json.parse(json_string)
		if not parseResult == OK:
			push_warning("JSON Parse Error: '", json.get_error_message(), "'  at line ", str(json.get_error_line()))
			continue
		var save_dict: Dictionary = json.get_data()
##
		if save_dict.has("master_volume_linear"):
			master_volume_linear = save_dict["master_volume_linear"]
		if save_dict.has("music_volume_linear"):
			music_volume_linear = save_dict["music_volume_linear"]
		if save_dict.has("sfx_volume_linear"):
			sfx_volume_linear = save_dict["sfx_volume_linear"]
		if save_dict.has("ambience_volume_linear"):
			ambience_volume_linear = save_dict["ambience_volume_linear"]
		if save_dict.has("master_volume_muted"):
			master_volume_muted = save_dict["master_volume_muted"]
		if save_dict.has("music_volume_muted"):
			music_volume_muted = save_dict["music_volume_muted"]
		if save_dict.has("sfx_volume_muted"):
			sfx_volume_muted = save_dict["sfx_volume_muted"]
		if save_dict.has("ambience_volume_muted"):
			ambience_volume_muted = save_dict["ambience_volume_muted"]

		if save_dict.has("fullscreen_active"):
			fullscreen_active = save_dict["fullscreen_active"]

		if save_dict.has("skip_intro_active"):
			skip_intro_active = save_dict["skip_intro_active"]
		
		if save_dict.has("locale"):
			locale = save_dict["locale"]
			
func set_master_volume(vol_new: float, do_save: bool = true) -> void:
	master_volume_linear = vol_new
	if do_save:
		save_to_file()

func set_music_volume(vol_new: float, do_save: bool = true) -> void:
	music_volume_linear = vol_new
	if do_save:
		save_to_file()

func set_sfx_volume(vol_new: float, do_save: bool = true) -> void:
	sfx_volume_linear = vol_new
	if do_save:
		save_to_file()

func set_ambience_volume(vol_new: float, do_save: bool = true) -> void:
	ambience_volume_linear = vol_new
	if do_save:
		save_to_file()

func set_master_volume_muted(muted_new: bool, do_save: bool = true) -> void:
	master_volume_muted = muted_new
	if do_save:
		save_to_file()

func set_music_volume_muted(muted_new: bool, do_save: bool = true) -> void:
	music_volume_muted = muted_new
	if do_save:
		save_to_file()

func set_sfx_volume_muted(muted_new: bool, do_save: bool = true) -> void:
	sfx_volume_muted = muted_new
	if do_save:
		save_to_file()

func set_ambience_volume_muted(muted_new: bool, do_save: bool = true) -> void:
	ambience_volume_muted = muted_new
	if do_save:
		save_to_file()

func set_locale(locale_new: LocaleItem, do_save: bool = true) -> void:
	locale = locale_new
	locale_changed.emit()
	if do_save:
		save_to_file()

func set_fullscreen_active(fs_active_new: bool, do_save: bool = true) -> void:
	fullscreen_active = fs_active_new
	if do_save:
		save_to_file()

func set_skip_intro_active(skip_intro_active_new: bool, do_save: bool = true) -> void:
	skip_intro_active = skip_intro_active_new
	if do_save:
		save_to_file()
	
static func set_fullscreen(is_fullscreen: bool) -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, FULLSCREEN_IS_BORDERLESS)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

static func to_short_locale(locale_item: LocaleItem) -> String:
	return str(SettingsIOClass.LocaleItem.keys()[locale_item]).to_lower()

static func is_web_build() -> bool:
	return OS.has_feature("web")
