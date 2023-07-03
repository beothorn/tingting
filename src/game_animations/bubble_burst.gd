extends Node

class_name BubbleBurst

@onready var sprite: Sprite2D = $Sprite

func _ready():
	sprite.rotation = randf_range(0.0,(PI*2))

func animate_on(pos: Vector2, size: float) -> void:
	sprite.position = pos
	var time = 0.2
	var relative_scale = size/324
	var relative_scale_burst = relative_scale*1.3
	
	sprite.scale = Vector2(relative_scale, relative_scale)
	sprite.modulate = Color(1, 1, 1, 1)
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(sprite, "scale", Vector2(relative_scale_burst, relative_scale_burst), time).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var modulate_tween: Tween = create_tween()
	modulate_tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.2), time).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUINT)
	scale_tween.tween_callback(queue_free)
	scale_tween.play()
	modulate_tween.play()
