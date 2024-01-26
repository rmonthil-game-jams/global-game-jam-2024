extends Node2D

func _ready():
	for a in get_children():
		if a is RigidBody2D:
			for b in get_children():
				if b is RigidBody2D:
					a.add_collision_exception_with(b)
