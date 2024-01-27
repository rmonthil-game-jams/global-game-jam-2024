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
	if overlapping_bodies.is_empty():
		# deactivating FootShadow
		$FootShadow.hide()
		# activating FootBody
		$FootBody.show()
		$FootBody.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		for body in overlapping_bodies:
			match body.name:
				"ForearmLeft":
					body.get_parent().stun_left()
				"ForearmRight":
					body.get_parent().stun_right()
				"Body":
					body.get_parent().die()
				_:
					push_error("body name not recognised")
