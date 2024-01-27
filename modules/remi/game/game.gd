extends Node

func _ready():
	randomize()
	$Processes/q.start()
	set_process_input(false)

func on_pigeon_just_died():
	# score
	var pigeon: Node2D = get_node("World/Pigeon")
	$CanvasLayerUI/Control/Info/HBoxContainer/VBoxContainer/ScoreLeft.text = str(pigeon.score_left)
	$CanvasLayerUI/Control/Info/HBoxContainer/VBoxContainer2/ScoreRight.text = str(pigeon.score_right)
	## pigeon corps
	#var pigeon_corps: Node2D = get_node("World/PigeonCorps")
	# zoom
	var tween_zoom: Tween = create_tween()
	tween_zoom.tween_property($Env/Camera2D, "global_position", get_node("World/Pigeon/Body").global_position, 1.0).set_trans(Tween.TRANS_QUAD)
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
	await get_tree().create_timer(1.0).timeout
	# input
	$CanvasLayerUI/Control/Info/Label.show()
	$CanvasLayerUI/Control/Info/Label.modulate.a = 0.0
	play_key_pressed_animation()
	set_process_input(true)

func _input(event: InputEvent):
	if event is InputEventKey:
		on_key_pressed()
	elif event is InputEventMouseButton:
		on_key_pressed()

var tween_play_key_pressed: Tween
func play_key_pressed_animation():
	tween_play_key_pressed = create_tween()
	tween_play_key_pressed.tween_property($CanvasLayerUI/Control/Info/Label, "modulate:a", 0.5, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_play_key_pressed.tween_property($CanvasLayerUI/Control/Info/Label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_play_key_pressed.finished
	play_key_pressed_animation.call_deferred()

func on_key_pressed():
	set_process_input(false)
	if tween_play_key_pressed:
		tween_play_key_pressed.kill()
	var tween_white: Tween = create_tween()
	tween_white.tween_property($CanvasLayerUI/Control/Info, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_white.finished
	# restart
	get_tree().reload_current_scene()

func _on_timer_win_check_timeout():
	if get_tree().get_nodes_in_group("target_to_kill").is_empty():
		# victory
		on_pigeon_just_died()
