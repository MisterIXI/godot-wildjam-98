extends Node

@onready var ship_log: Control = $ShipLog

var test_Test = 1

func _on_timer_timeout() -> void:
	test_Test += 1
	GlobalLog.log_text = "Test dialog ist hier" + str(test_Test)
	ship_log.newLine()
	
