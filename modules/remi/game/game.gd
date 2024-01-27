extends Node

func _ready():
	randomize()
	$Processes/WalkPathSerie.start()

func on_pigeon_just_died():
	# score
	var pigeon: Node2D = get_node("World/Pigeon")
	$CanvasLayerUI/Control/Info/HBoxContainer/VBoxContainer/ScoreLeft.text = str(pigeon.score_left)
	$CanvasLayerUI/Control/Info/HBoxContainer/VBoxContainer2/ScoreRight.text = str(pigeon.score_right)
	# pigeon corps
	var pigeon_corps: Node2D = get_node("World/PigeonCorps")
	# zoom
	var tween_zoom: Tween = create_tween()
	tween_zoom.tween_property($Env/Camera2D, "global_position", pigeon_corps.global_position, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_zoom.parallel().tween_property($Env/Camera2D, "zoom", 1.5 * Vector2.ONE, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_zoom.finished
	# white
	## show
	$CanvasLayerUI/Control.modulate.a = 0.0
	$CanvasLayerUI.show()
	## tween
	var tween_white: Tween = create_tween()
	tween_white.tween_property($CanvasLayerUI/Control, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_white.finished
	$Back.queue_free()
	$World.queue_free()
	$Env.queue_free()
	await get_tree().create_timer(4.0).timeout
	tween_white = create_tween()
	tween_white.tween_property($CanvasLayerUI/Control/Info, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_white.finished
	# restart
	get_tree().reload_current_scene()
