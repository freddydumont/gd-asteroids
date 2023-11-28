class_name Asteroid
extends Entity

enum AsteroidSize {
	SMALL,
	MEDIUM,
	LARGE,
}

## Size declared here should match Sprite
@export var size: AsteroidSize

## position is global_position of the destroyed asteroid
signal destroyed(size: AsteroidSize, position: Vector2, velocity: Vector2, rotation: float)


# TODO: add asteroid destroyed animation
func hit(_damage: int):
	# at global_position, add two asteroids of the smaller size
	destroyed.emit(size, global_position, linear_velocity, angular_velocity)
	queue_free()
