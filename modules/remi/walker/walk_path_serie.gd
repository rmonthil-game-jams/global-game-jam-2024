extends Node

@export_node_path("Node2D") var world_path: NodePath
@export var walk_path_scenes: Array[PackedScene]
@export var walk_path_delays: Array[float]

func start():
	for index in range(walk_path_scenes.size()):
		await get_tree().create_timer(walk_path_delays[index]).timeout
		get_node(world_path).add_child(walk_path_scenes[index].instantiate())
	await get_tree().create_timer(4.0).timeout
	get_parent().get_parent().on_pigeon_just_died()
	queue_free()
