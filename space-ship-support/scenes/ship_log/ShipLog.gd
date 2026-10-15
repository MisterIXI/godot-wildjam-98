extends Control


@onready var v_box_container: VBoxContainer = $lContainer/VBoxContainer



var new_label
var Last_label
 
func _ready():
	#var log_text = "Test"
	#new_label = Label.new()
	#log_text = "Test"
	#new_label.text = str(log_text)
	#vbox_container.add_child(new_label)
	#log_text = "Test2"
	#new_label = Label.new()
	#new_label.text = str(log_text)
	#vbox_container.add_child(new_label)
	pass

func newLine():
	new_label = preload("res://scenes/ship_log/Ship_log_text.tscn")
	new_label = new_label.instantiate()
	new_label.text = str(GlobalLog.log_text)
	v_box_container.add_child(new_label)
	pass
