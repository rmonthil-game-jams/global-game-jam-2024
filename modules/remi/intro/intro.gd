extends Control

var tween_pigeon: Tween
var tween_dove: Tween

@onready var init_pigeon_position: Vector2 = $IntroPigeon.position
@onready var init_dove_position: Vector2 = $IntroDove.position

func _ready():
	play_pigeon_animation()
	play_dove_animation()
	play_key_pressed_animation()

func play_pigeon_animation():
	$IntroPigeon/AudioStreamPlayer2D.play()
	tween_pigeon = create_tween()
	tween_pigeon.tween_property($IntroPigeon, "position", init_pigeon_position + Vector2(randf_range(-64, 64), randf_range(-64, 64)), randf_range(0.125, 1.0))
	tween_pigeon.parallel().tween_property($IntroPigeon, "rotation", randf_range(-0.125*0.125*PI, 0.125*0.125*PI), randf_range(0.125, 1.0))
	await  tween_pigeon.finished
	play_pigeon_animation.call_deferred()

func play_dove_animation():
	$IntroDove/AudioStreamPlayer2D.play()
	tween_dove = create_tween()
	tween_dove.tween_property($IntroDove, "position", init_dove_position + Vector2(randf_range(-64, 64), randf_range(-64, 64)), randf_range(0.125, 1.0))
	tween_dove.parallel().tween_property($IntroDove, "rotation", randf_range(-0.125*0.125*PI, 0.125*0.125*PI), randf_range(0.125, 1.0))
	await  tween_dove.finished
	play_dove_animation.call_deferred()

var tween_play_key_pressed: Tween
func play_key_pressed_animation():
	tween_play_key_pressed = create_tween()
	tween_play_key_pressed.tween_property($Label, "modulate:a", 0.25, 1.0).set_trans(Tween.TRANS_QUAD)
	tween_play_key_pressed.tween_property($Label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_play_key_pressed.finished

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

func on_key_pressed():
	set_process_input(false)
	$Title.hide()
	$Label.hide()
	# kill
	tween_pigeon.kill()
	tween_dove.kill()
	if tween_play_key_pressed:
		tween_play_key_pressed.kill()
	tween_pigeon = create_tween()
	tween_pigeon.tween_property($IntroPigeon, "position", init_pigeon_position, 0.125)
	tween_pigeon.parallel().tween_property($IntroPigeon, "rotation", 0.0, 0.125)
	tween_pigeon.tween_interval(2.25)
	tween_pigeon.tween_property($IntroPigeon, "position:x", -$Wheel.position.x, 0.125)
	tween_dove = create_tween()
	tween_dove.tween_property($IntroDove, "position", init_dove_position, 0.125)
	tween_dove.parallel().tween_property($IntroDove, "rotation", 0.0, 0.125)
	tween_dove.tween_interval(2.25)
	tween_dove.tween_property($IntroDove, "position:x", -$Wheel.position.x, 0.125)
	
	$AudioStreamPlayerHorn.play()
	$AudioStreamPlayerCrash.play()
	await get_tree().create_timer(2.0).timeout
	
	var tween_color: Tween = create_tween()
	tween_color.tween_interval(0.5)
	tween_color.tween_property($ColorRect, "modulate", Color(0.5, 0.25, 0.25), 0.45).set_trans(Tween.TRANS_QUAD)
	
	var tween_wheel: Tween = create_tween()
	tween_wheel.tween_property($Wheel, "position:x", -$Wheel.position.x, 1.0).set_trans(Tween.TRANS_QUAD)
	await tween_wheel.finished
	
	tween_color = create_tween()
	tween_color.tween_property($ColorRect, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD)
	await tween_color.finished
	
	await get_tree().create_timer(1.0).timeout
	get_parent().get_parent().start()

func _process(delta: float):
	$Wheel.rotate(-4.0*PI*delta)
