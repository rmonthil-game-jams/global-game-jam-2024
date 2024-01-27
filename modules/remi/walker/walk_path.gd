extends Node2D

# parameters

@export var LENGTH_INTERVAL: float
@export var TIME_INTERVAL: float

@onready var is_left_first: bool = randf_range(0.0, 1.0) <= 0.5

func _ready():
	if is_left_first:
		$Path2D/PathFollow2DLeft.progress += 0.5 * LENGTH_INTERVAL
	else:
		$Path2D/PathFollow2DRight.progress += 0.5 * LENGTH_INTERVAL
	# start to walk
	_walk.call_deferred()

func _walk():
	while($Path2D/PathFollow2DLeft.progress_ratio < 1.0 and $Path2D/PathFollow2DRight.progress_ratio < 1.0):
		var tween: Tween
		if is_left_first:
			tween = create_tween()
			tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).start_step)
			tween.tween_property($Path2D/PathFollow2DRight, "progress", $Path2D/PathFollow2DRight.progress + LENGTH_INTERVAL, TIME_INTERVAL).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).end_step)
			tween = create_tween()
			tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).start_step)
			tween.tween_property($Path2D/PathFollow2DLeft, "progress", $Path2D/PathFollow2DLeft.progress + LENGTH_INTERVAL, TIME_INTERVAL).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).end_step)
			await tween.finished
		else:
			tween = create_tween()
			tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).start_step)
			tween.tween_property($Path2D/PathFollow2DLeft, "progress", $Path2D/PathFollow2DLeft.progress + LENGTH_INTERVAL, TIME_INTERVAL).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).end_step)
			await tween.finished
			tween = create_tween()
			tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).start_step)
			tween.tween_property($Path2D/PathFollow2DRight, "progress", $Path2D/PathFollow2DRight.progress + LENGTH_INTERVAL, TIME_INTERVAL).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
			tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).end_step)
			await tween.finished
	queue_free()
