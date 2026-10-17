class_name MainMenu
extends Control

@export_file("*.tscn") var game_scene_path: String

@export var main_vbc: VBoxContainer
@export var settings_container: Control
@export var credits_container: Control

func _ready() -> void:
	_show_start_menu()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _show_start_menu() -> void:
	Utils.set_visible_only(main_vbc, [settings_container, credits_container])

func _on_settings_button_pressed() -> void:
	Utils.set_visible_only(settings_container, [main_vbc, credits_container])

func _on_credits_button_pressed() -> void:
	Utils.set_visible_only(credits_container, [main_vbc, settings_container])


func _on_back_button_pressed() -> void:
	_show_start_menu()
