extends Node

func _ready():
	randomize()
	$Processes/WalkPathSerie.start()
