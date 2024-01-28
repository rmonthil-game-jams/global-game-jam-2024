extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# scale
	scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
	rotation = randf_range(-PI, PI)
	# anim
	var tween: Tween = create_tween()
	tween.tween_interval(4.0)
	tween.tween_property(self, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
