class_name GameOver
extends Control

@export_file("*.tscn") var main_menu_scene: String

@onready var time_nummber: Label = $Window/ContentMarginContainer/VBoxContainer/GridContainer/TimeNummber
@onready var ships_fixed_nummber: Label = $Window/ContentMarginContainer/VBoxContainer/GridContainer/ShipsFixedNummber
@onready var strikes_nummber: Label = $Window/ContentMarginContainer/VBoxContainer/GridContainer/StrikesNummber
@onready var total_pay_nummber: Label = $Window/ContentMarginContainer/VBoxContainer/HBoxContainer/TotalPayNummber


# func _ready() -> void:
# 	visible = false

# Called when the node enters the scene tree for the first time.
func active(time,fixed,strikes) -> void:
	time_nummber.text = str(time)
	ships_fixed_nummber.text = str(fixed)
	strikes_nummber.text = str(strikes)
	visible = true
	get_tree().paused = true


func _on_button_button_down() -> void:
	print("Test")
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file(main_menu_scene)
