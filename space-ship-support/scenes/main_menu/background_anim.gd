class_name BackgroundAnim extends Control


@export var active: bool = true
@export_range(0.05, 5.0) var frequency: float = 0.5
@export_range(0.1, 8.0) var lifetime: float = 1.0


func _ready() -> void:
	start_spawn_timer()

	
func start_spawn_timer() -> void:
	if (!active):
		return

	var timer: SceneTreeTimer = get_tree().create_timer(randf_range(frequency * 0.75, frequency * 1.25))
	timer.timeout.connect(spawn_label)

func spawn_label() -> void:
	var pos: Vector2 = Vector2(randf_range(0.0, get_viewport_rect().size.x), randf_range(0.0, get_viewport_rect().size.y))
	var label: Label = Label.new()
	label.modulate = Color.DIM_GRAY
	label.global_position = pos
	label.text = "S" if randf() < 0.9 else "T"
	add_child(label)
	
	var tween: Tween = get_tree().create_tween().set_parallel(true)
	var this_lifetime = randf_range(lifetime * 0.75, lifetime * 1.25)
	tween.tween_property(label, "modulate:a", 0.0, this_lifetime * 0.95)
	tween.tween_property(label, "global_position", Vector2(pos.x, pos.y - 400), this_lifetime)

	tween.finished.connect(queue_free_label.bind(label))
	
	start_spawn_timer()

func queue_free_label(label: Label) -> void:
	label.queue_free()
