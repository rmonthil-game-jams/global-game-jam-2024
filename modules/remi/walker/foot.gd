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
	if not overlapping_bodies.is_empty():
		var pigeon: Node2D = overlapping_bodies.front().get_parent()
		for body in overlapping_bodies:
			match body.name:
				"ForearmLeft":
					pigeon.stun_left()
					if pigeon.state_left == "hitting":
						# TODO: hit animation
						queue_free()
				"ForearmRight":
					pigeon.stun_right()
					if pigeon.state_right == "hitting":
						# TODO: hit animation
						queue_free()
				"Body":
					body.get_parent().die()
				_:
					push_error("body name not recognised")
