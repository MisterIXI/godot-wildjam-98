extends Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var num_off_letters

func _ready() -> void:
	visible_characters = 0
	var tween = create_tween()
	tween.tween_property($".","visible_characters",get_total_character_count(),0.3)
	



func _on_area_2d_area_entered(area: Area2D) -> void:
	animation_player.play("disapear")
