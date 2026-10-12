extends Control

@onready var vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer


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
	#position.y -= 30
	new_label = Label.new()
	new_label.text = str(GlobalLog.log_text)
	vbox_container.add_child(new_label)
	pass
