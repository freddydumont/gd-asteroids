class_name AsteroidScenes
extends Resource

@export var large: Array[PackedScene]
@export var medium: Array[PackedScene]
@export var small: Array[PackedScene]


func random():
	return (large if randi() % 2 else medium).pick_random()


## Splits asteroids into two smaller sizes
## TODO: fix scale bug with small asteroids
func split(size: Asteroid.AsteroidSize) -> Array[PackedScene]:
	match size:
		Asteroid.AsteroidSize.LARGE:
			return [medium.pick_random(), medium.pick_random()]
		Asteroid.AsteroidSize.MEDIUM:
			return [small.pick_random(), small.pick_random()]
		_:
			return []
		