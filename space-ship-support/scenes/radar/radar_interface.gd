class_name RadarInterface
extends Control

@export var scroll_content: VBoxContainer
@export var strike_texs: Array[TextureRect]
@export var score_label: Label
@export var font: FontFile
var labels: Array[Label] = []

func _ready() -> void:
	score_label.text= "%s: %d\n%s: %d sec" % [tr("ui.ships_fixed"), 0, tr("ui.time_elapsed"), 0]


func add_message(message: String) -> void:
	var new_label: Label = Label.new()
	scroll_content.add_child(new_label)
	new_label.text = message
	new_label.set("theme_override_fonts/font", font)
	labels.append(new_label)
	var tween = new_label.create_tween()
	new_label.visible_characters = 0
	tween.tween_property(new_label, "visible_characters",message.length(),0.6)
	new_label.set("theme_override_colors/font_color", Color.GREEN)
	if labels.size() >= 17:
		labels.pop_front().queue_free()

# var time: float = 0
# var counter: float = 1

# func _physics_process(delta: float) -> void:
# 	time += delta
# 	counter -= delta
# 	if counter <= 0:
# 		counter = 0.3

# 		add_message("%d Current Time: %d %d" % [randi(),time,randi()])
