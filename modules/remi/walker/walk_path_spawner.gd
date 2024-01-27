extends Node

@export_node_path("Node2D") var world_path: NodePath
@export var walker_scenes: Array[PackedScene]

func _ready():
	_on_timer_timeout()

func _on_timer_timeout():
	get_node(world_path).add_child(walker_scenes.pick_random().instantiate())
