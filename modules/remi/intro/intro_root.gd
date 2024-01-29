extends Node

func start():
	var tween_color: Tween = create_tween()
	tween_color.tween_property($World/Eclatos, "modulate", Color(0.0, 0.0, 0.0), 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($World/Pigeon.show)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer.play)
	
	tween_color.tween_property($World/Pigeon, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 1.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer2.play)
	
	
	tween_color.parallel().tween_property($World/Eclatos, "modulate:a", 0.0, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_property($World/Pigeon, "modulate", Color.WHITE, 0.125).set_trans(Tween.TRANS_QUAD)
	tween_color.tween_callback($AudioStreamPlayer3.play)
	tween_color.tween_interval(2.0)
	
	await tween_color.finished
	
	get_tree().change_scene_to_file("res://modules/remi/game/game.tscn")
