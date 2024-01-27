extends Node

func _ready():
	randomize()
	$ProcessesGD/WalkPathSerie.start()
