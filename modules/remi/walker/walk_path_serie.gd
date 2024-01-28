extends Node

@export_node_path("Node2D") var world_path: NodePath
@export_node_path("Label") var game_over_path: NodePath
@export_node_path("Control") var levels_path: NodePath

@export var walk_path_scenes: Array[PackedScene]
@export var walk_path_delays: Array[float]

var level_index: int = 1

func start():
	_play_anim(get_node(levels_path).get_child(0))
	for index in range(walk_path_scenes.size()):
		if walk_path_delays[index] >= 10.0:
			await get_tree().create_timer(walk_path_delays[index] - 4.0).timeout
			_play_anim(get_node(levels_path).get_child(level_index))
			await get_tree().create_timer(4.0).timeout
			level_index += 1
		else:
			await get_tree().create_timer(walk_path_delays[index]).timeout
		if has_node(world_path):
			get_node(world_path).add_child(walk_path_scenes[index].instantiate())
		else:
			queue_free()
			return
	get_node(game_over_path).get_node("GameOver").hide()
	get_node(game_over_path).get_node("DevAlwaysWins").show()
	queue_free()

func _play_anim(label: Label):
	var tween: Tween = create_tween()
	tween.tween_callback(label.show)
	tween.tween_property(label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(2.0)
	tween.tween_property(label, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD)
	tween.tween_callback(label.hide)
