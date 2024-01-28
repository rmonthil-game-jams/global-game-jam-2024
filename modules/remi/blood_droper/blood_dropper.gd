extends Area2D

func _on_body_exited(body: RigidBody2D):
	(
		func ():
			var new_blood: Node2D = preload("res://modules/remi/blood_droper/blood.tscn").instantiate()
			get_parent().get_parent().add_child(new_blood)
			new_blood.global_position = body.global_position
			position = body.position
	).call_deferred()
