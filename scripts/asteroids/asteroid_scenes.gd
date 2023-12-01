class_name AsteroidScenes
extends Resource

@export var large: Array[PackedScene]
@export var medium: Array[PackedScene]
@export var small: Array[PackedScene]


func random():
	return large.pick_random()


## Splits asteroids into two smaller sizes
func split(size: Asteroid.AsteroidSize) -> Array[PackedScene]:
	match size:
		Asteroid.AsteroidSize.LARGE:
			get_local_scene().get_node("AsteroidExplosionLarge").play()
			return [medium.pick_random(), medium.pick_random()]
		Asteroid.AsteroidSize.MEDIUM:
			get_local_scene().get_node("AsteroidExplosionMedium").play()
			return [small.pick_random(), small.pick_random()]
		_:
			get_local_scene().get_node("AsteroidExplosionSmall").play()
			return []
