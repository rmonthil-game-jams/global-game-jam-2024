extends Node2D

@export var REACTION_TIME: float

@onready var player_keyboard_left: Node = get_tree().root.get_node("Game/Players/PlayerKeyboardLeft")
@onready var player_keyboard_right: Node = get_tree().root.get_node("Game/Players/PlayerKeyboardRight")

var state_left: String = "idle"
var state_right: String = "idle"

var score_left: int = 0
var score_right: int = 0

func stun_left():
	state_left = "stunned"
	$TimerStunLeft.start()

func stun_right():
	state_right = "stunned"
	$TimerStunRight.start()

func die():
	player_keyboard_left.queue_free()
	player_keyboard_right.queue_free()
	# corps
	var new_corps: Node2D = preload("res://modules/remi/pigeon/pigeon_corps.tscn").instantiate()
	new_corps.position = transform * $Body.position
	get_parent().add_child(new_corps)
	# warn game of death
	var game: Node = get_parent().get_parent()
	game.on_pigeon_just_died()
	# free
	queue_free()

# internal

func _ready():
	for a in get_children():
		if a is RigidBody2D:
			for b in get_children():
				if b is RigidBody2D:
					a.add_collision_exception_with(b)

func _physics_process(delta: float):
	$Body.apply_impulse(-$Body.mass * $Body.linear_velocity * delta / REACTION_TIME)

# timer callbacks

func _on_time_stun_left_timeout():
	state_left = "idle"

func _on_time_stun_right_timeout():
	state_right = "idle"

func _on_time_hit_right_cooldown_timeout():
	state_right = "idle"

func _on_time_hit_left_cooldown_timeout():
	state_left = "idle"

func _on_timer_hit_right_timeout():
	state_right = "cooling"
	$TimerHitRightCooldown.start()

func _on_timer_hit_left_timeout():
	state_left = "cooling"
	$TimerHitLeftCooldown.start()