extends Control

@onready var vbox_container: VBoxContainer = $ScrollContainer/VBoxContainer



 
func _ready():
	var new_label = Label.new()
	new_label.text = "Test"
	vbox_container.add_child(new_label)
	new_label = Label.new()
	new_label.text = "Test2"
	vbox_container.add_child(new_label)

func newLine():
	pass

