extends Node2D

@export var REACTION_TIME: float

@onready var players: Node = get_tree().root.get_node("Game/Players")

var state_left: String = "idle"
var state_right: String = "idle"

var score_left: int = 0
var score_right: int = 0

func stun_left():
	state_left = "stunned"
	$TimerStunLeft.start()
	$ForearmLeft/AudioStreamPlayer2DStun.play()
	$ForearmLeft.modulate.v = 0.5

func hit_left():
	state_left = "hitting"
	$TimerHitLeft.start()
	var tween: Tween = create_tween()
	tween.tween_property($ForearmLeft/Sprite2D/Sprite2DBone, "position", $ForearmLeft/Sprite2D/Marker2DOut.position, 0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$ForearmLeft/Sprite2D2Hit.show()
	$ForearmLeft/AudioStreamPlayer2DHit.play()

func stun_right():
	state_right = "stunned"
	$TimerStunRight.start()
	$ForearmRight/AudioStreamPlayer2DStun.play()
	$ForearmRight.modulate.v = 0.5

func hit_right():
	state_right = "hitting"
	$TimerHitRight.start()
	var tween: Tween = create_tween()
	tween.tween_property($ForearmRight/Sprite2D/Sprite2DFeather, "position", $ForearmRight/Sprite2D/Marker2DOut.position, 0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$ForearmRight/Sprite2DHit.show()
	$ForearmRight/AudioStreamPlayer2DHit.play()

func die():
	for player in players.get_children():
		player.queue_free()
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
	$ForearmLeft.modulate.v = 1.0

func _on_time_stun_right_timeout():
	state_right = "idle"
	$ForearmRight.modulate.v = 1.0

func _on_time_hit_right_cooldown_timeout():
	state_right = "idle"

func _on_time_hit_left_cooldown_timeout():
	state_left = "idle"

func _on_timer_hit_right_timeout():
	state_right = "cooling"
	var tween: Tween = create_tween()
	tween.tween_property($ForearmRight/Sprite2D/Sprite2DFeather, "position", $ForearmRight/Sprite2D/Marker2DIn.position, 0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$ForearmRight/Sprite2DHit.hide()
	$TimerHitRightCooldown.start()

func _on_timer_hit_left_timeout():
	var tween: Tween = create_tween()
	tween.tween_property($ForearmLeft/Sprite2D/Sprite2DBone, "position", $ForearmLeft/Sprite2D/Marker2DIn.position, 0.125).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	$ForearmLeft/Sprite2D2Hit.hide()
	state_left = "cooling"
	$TimerHitLeftCooldown.start()

func _on_forearm_left_body_entered(body: StaticBody2D):
	if state_left == "hitting":
		if body.get_parent().name != "Borders":
			score_left += 1
			body.get_parent().play_hit_pigeon_animation()
			$ForearmLeft/AudioStreamPlayer2DHitFoot.play()

func _on_forearm_right_body_entered(body: StaticBody2D):
	if state_right == "hitting":
		if body.get_parent().name != "Borders":
			score_right += 1
			body.get_parent().play_hit_dove_animation()
			$ForearmRight/AudioStreamPlayer2DHitFoot.play()
