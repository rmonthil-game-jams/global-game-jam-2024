extends Node2D

# parameters

@export var STEP_LENGTH_INTERVAL: Array[float]
@export var STEP_TIME_INTERVAL: Array[float]
@export var SLIDE_LENGTH_INTERVAL: Array[float]
@export var SLIDE_TIME_INTERVAL: Array[float]

@onready var is_left_first: bool = true#randf_range(0.0, 1.0) <= 0.5

var step_index: int = 0

func _ready():
	if is_left_first:
		$Path2D/PathFollow2DLeft.progress += 0.5 * STEP_LENGTH_INTERVAL[0]
		_step_right.call_deferred()
	else:
		$Path2D/PathFollow2DRight.progress += 0.5 * STEP_LENGTH_INTERVAL[0]
		_step_left.call_deferred()

func _step_right():
	var tween: Tween = create_tween()
	if $Path2D/PathFollow2DRight.get_children():
		tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).start_step)
		var tween_shadow_scale: Tween = create_tween()
		var tween_shadow_opacity: Tween = create_tween()
		tween_shadow_scale.tween_property($Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D"), "scale", 1.5 * $Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D").scale, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_scale.tween_property($Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D"), "scale", $Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D").scale, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_opacity.tween_property($Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D"), "modulate:a", 0.25, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_opacity.tween_property($Path2D/PathFollow2DRight.get_child(0).get_node("FootShadow/Sprite2D"), "modulate:a", 1.0, 0.5 * STEP_TIME_INTERVAL[step_index])
	tween.tween_property($Path2D/PathFollow2DRight, "progress", $Path2D/PathFollow2DRight.progress + STEP_LENGTH_INTERVAL[step_index], STEP_TIME_INTERVAL[step_index]).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if $Path2D/PathFollow2DRight.get_children():
		tween.tween_callback($Path2D/PathFollow2DRight.get_child(0).end_step)
	await tween.finished
	_slide_right.call_deferred()

func _slide_right():
	var tween: Tween = create_tween()
	tween.tween_property($Path2D/PathFollow2DRight, "progress", $Path2D/PathFollow2DRight.progress +  SLIDE_LENGTH_INTERVAL[step_index], SLIDE_TIME_INTERVAL[step_index]).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	step_index = (step_index + 1) % STEP_LENGTH_INTERVAL.size()
	if $Path2D/PathFollow2DLeft.progress_ratio < 1.0 and $Path2D/PathFollow2DRight.progress_ratio < 1.0:
		_step_left.call_deferred()
	else:
		queue_free()

func _step_left():
	var tween: Tween = create_tween()
	if $Path2D/PathFollow2DLeft.get_children():
		tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).start_step)
		var tween_shadow_scale: Tween = create_tween()
		var tween_shadow_opacity: Tween = create_tween()
		tween_shadow_scale.tween_property($Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D"), "scale", 1.5 * $Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D").scale, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_scale.tween_property($Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D"), "scale", $Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D").scale, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_opacity.tween_property($Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D"), "modulate:a", 0.25, 0.5 * STEP_TIME_INTERVAL[step_index])
		tween_shadow_opacity.tween_property($Path2D/PathFollow2DLeft.get_child(0).get_node("FootShadow/Sprite2D"), "modulate:a", 1.0, 0.5 * STEP_TIME_INTERVAL[step_index])
	tween.tween_property($Path2D/PathFollow2DLeft, "progress", $Path2D/PathFollow2DLeft.progress + STEP_LENGTH_INTERVAL[step_index], STEP_TIME_INTERVAL[step_index]).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	if $Path2D/PathFollow2DLeft.get_children():
		tween.tween_callback($Path2D/PathFollow2DLeft.get_child(0).end_step)
	await tween.finished
	_slide_left.call_deferred()

func _slide_left():
	var tween: Tween = create_tween()
	tween.tween_property($Path2D/PathFollow2DLeft, "progress", $Path2D/PathFollow2DLeft.progress +  SLIDE_LENGTH_INTERVAL[step_index], SLIDE_TIME_INTERVAL[step_index]).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	await tween.finished
	step_index = (step_index + 1) % STEP_LENGTH_INTERVAL.size()
	if $Path2D/PathFollow2DLeft.progress_ratio < 1.0 and $Path2D/PathFollow2DRight.progress_ratio < 1.0:
		_step_right.call_deferred()
	else:
		queue_free()
