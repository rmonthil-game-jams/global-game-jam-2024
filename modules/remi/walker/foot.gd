extends Node2D

func _ready():
	# TODO: WEAK POINTS
	pass

func start_step():
	# activating FootShadow
	$FootShadow.show()
	# deactivating FootBody
	$FootBody.process_mode = Node.PROCESS_MODE_DISABLED
	$FootBody.hide()

func end_step():
	# check if pigeon is inside
	var overlapping_bodies: Array = $FootShadow.get_overlapping_bodies()
	# deactivating FootShadow
	$FootShadow.hide()
	# activating FootBody
	$FootBody.show()
	$FootBody.process_mode = Node.PROCESS_MODE_INHERIT
	# empty
	if not overlapping_bodies.is_empty():
		var pigeon: Node2D = overlapping_bodies.front().get_parent()
		for body in overlapping_bodies:
			match body.name:
				"ForearmLeft":
					pigeon.stun_left()
					if pigeon.state_left == "hitting":
						$FootBody.process_mode = Node.PROCESS_MODE_DISABLED
						# free
						queue_free()
				"ForearmRight":
					pigeon.stun_right()
					if pigeon.state_right == "hitting":
						$FootBody.process_mode = Node.PROCESS_MODE_DISABLED
						# anim
						## init
						$FootBody/Sprite2D2.hide()
						$FootBody/Sprite2D2HitDove.show()
						## tween
						var tween: Tween = create_tween()
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", -0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", 0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", -0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", 0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", -0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", 0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", -0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "rotation", 0.125*PI, 0.125).set_trans(Tween.TRANS_CUBIC)
						tween.tween_property($FootBody/Sprite2DHitDove, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
						await tween.finished
						# free
						queue_free()
				"Body":
					body.get_parent().die()
				_:
					push_error("body name not recognised")

func _play_hit_pigeon_animation():
	## init
	$FootBody/Sprite2D2HitPigeon.show()
	## tween
	var tween: Tween = create_tween()
	tween.tween_property($FootBody/Sprite2DHitDove, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tween.finished
