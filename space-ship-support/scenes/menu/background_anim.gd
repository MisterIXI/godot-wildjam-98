class_name BackgroundAnim extends Control

@export var active: bool = true
@export var vert_movement: int = 400
@export_range(0.05, 5.0) var frequency: float = 0.5
@export_range(0.1, 8.0) var lifetime: float = 1.0
@export_range(0, 0.75) var variance: float = 0.25

var min_variance: float = 1.0
var max_variance: float = 1.0


func _ready() -> void:
	start_spawn_timer()
	min_variance = 1 - variance
	max_variance = 1 / min_variance

func start_spawn_timer() -> void:
	if (!active):
		return

	var timer: SceneTreeTimer = get_tree().create_timer(randf_range(frequency * 0.75, frequency * 1.25))
	timer.timeout.connect(spawn_label)

func spawn_label() -> void:
	var used_vert_movement: float = randf_range(vert_movement * min_variance, vert_movement * max_variance)
	var pos: Vector2 = Vector2(randf_range(0.0, get_viewport_rect().size.x), randf_range(0.0, get_viewport_rect().size.y + (used_vert_movement * 0.9)))

	var label: Label = Label.new()
	var color: Color = Color("#667788")
	color.h = clampf(randf_range(color.h * min_variance, color.h * max_variance), 0.0, 1.0)
	color.s = clampf(randf_range(color.s * min_variance, color.s * max_variance), 0.0, 1.0)
	color.v = clampf(randf_range(color.v * min_variance, color.v * max_variance), 0.0, 1.0)
	label.modulate = color
	label.global_position = pos
	label.text = "S" if randf() < 0.9 else "T"
	add_child(label)
	if not get_tree():
		push_warning("wtf")
		return
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	var this_lifetime = randf_range(lifetime * min_variance, lifetime * max_variance)
	tween.tween_property(label, "modulate:a", 0.0, this_lifetime * 0.95)
	tween.tween_property(label, "global_position", Vector2(pos.x, pos.y - vert_movement), this_lifetime)
	
	if (label.text == "S" && randf() > 0.7):
		tween.tween_method(tween_letter.bind(label, "S", "T"), 0.0, 1.5, this_lifetime)
		
	if (label.text == "T" && randf() > 0.7):
		tween.tween_method(tween_letter.bind(label, "T", "S"), 0.0, 1.5, this_lifetime)
	
	tween.finished.connect(queue_free_label.bind(label))
	
	start_spawn_timer()

func tween_letter(progress: float, label: Label, start_letter: String, swap_letter: String) -> void:
	label.text = start_letter if (progress < 0.5 || progress > 0.75) else swap_letter

func queue_free_label(label: Label) -> void:
	label.queue_free()
