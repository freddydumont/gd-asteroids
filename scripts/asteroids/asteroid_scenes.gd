class_name AsteroidScenes
extends Resource

@export var large: Array[PackedScene]
@export var medium: Array[PackedScene]


func random():
	return (large if randi() % 2 else medium).pick_random()
