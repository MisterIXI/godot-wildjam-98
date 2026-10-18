class_name PauseMenu
extends Control

@export_file("*.tscn") var main_menu_scene: String

@export var main_vbc: VBoxContainer
@export var settings_container: Control
@export var quit_button: Button

var is_pause_menu_active: bool = false

func _ready() -> void:
	set_pause_view_active(false)
	quit_button.visible = !Utils.is_web_build()

func _show_pause_menu() -> void:
	Utils.set_visible_only(main_vbc, [settings_container])

func _on_settings_button_pressed() -> void:
	Utils.set_visible_only(settings_container, [main_vbc])

func _on_back_button_pressed() -> void:
	_show_pause_menu()
	
func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_resume_button_pressed() -> void:
	set_pause_view_active(false)
	
func set_pause_view_active(is_active_new: bool) -> void:
	if is_active_new && !is_pause_menu_active:
		_show_pause_menu()
	get_tree().paused = is_active_new
	visible = is_active_new
	is_pause_menu_active = is_active_new
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_game"):
		set_pause_view_active(!is_pause_menu_active)
