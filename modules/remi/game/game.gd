extends Node

var is_ending: bool = false

func _ready():
	randomize()
	$AudioStreamPlayerAmbiance.play()
	set_process_input(false)
	
	var tween_zoom: Tween = create_tween()
	tween_zoom.tween_property($Env/Camera2D, "zoom", 0.35 * Vector2.ONE, 2.0).set_trans(Tween.TRANS_QUAD)
	
	var tween_zqsd: Tween = create_tween()
	tween_zqsd.tween_interval(1.0)
	tween_zqsd.tween_property($Controls/ZQSD, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_zqsd.tween_interval(2.0)
	tween_zqsd.tween_property($Controls/ZQSD, "modulate:a", 0.0, 4.0).set_trans(Tween.TRANS_QUAD)
	
	var tween_arrows: Tween = create_tween()
	tween_arrows.tween_interval(1.0)
	tween_arrows.tween_property($Controls/Arrows, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_arrows.tween_interval(2.0)
	tween_arrows.tween_property($Controls/Arrows, "modulate:a", 0.0, 4.0).set_trans(Tween.TRANS_QUAD)

	await tween_zoom.finished
	$Processes/WalkPathSerie.start()

func on_pigeon_just_died():
	is_ending = true
	$AudioStreamPlayerLose.play()
	# score
	var pigeon: Node2D = get_node("World/Pigeon")
	$CanvasLayerUI/Control/Info/VBoxContainer/HBoxContainer/VBoxContainer/ScoreLeft.text = str(pigeon.score_left)
	$CanvasLayerUI/Control/Info/VBoxContainer/HBoxContainer/VBoxContainer2/ScoreRight.text = str(pigeon.score_right)
	# zoom
	var tween_zoom: Tween = create_tween()
	tween_zoom.tween_property($Env/Camera2D, "global_position", get_node("World/Pigeon/Body").global_position, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_zoom.parallel().tween_property($Env/Camera2D, "zoom", 0.9 * Vector2.ONE, 2.0).set_trans(Tween.TRANS_QUAD)
	tween_zoom.tween_interval(2.0)
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
		if event.pressed:
			on_key_pressed()
	elif event is InputEventMouseButton:
		if event.pressed:
			on_key_pressed()
	elif event is InputEventJoypadButton:
		if event.pressed:
			on_key_pressed()

var tween_play_key_pressed: Tween
func play_key_pressed_animation():
	tween_play_key_pressed = create_tween()
	tween_play_key_pressed.tween_property($CanvasLayerUI/Control/Info/Label, "modulate:a", 0.25, 1.0).set_trans(Tween.TRANS_QUAD)
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
	get_tree().change_scene_to_file("res://modules/remi/game/game.tscn")

func _on_timer_win_check_timeout():
	if not is_ending and get_tree().get_nodes_in_group("target_to_kill").is_empty():
		# victory
		for player in $Players.get_children():
			player.queue_free()
		# kill pigeon
		on_pigeon_just_died()

func _on_audio_stream_player_ambiance_finished():
	await get_tree().create_timer(1.0).timeout
	$AudioStreamPlayerAmbiance.play()
