class_name Asteroid
extends Entity

## position is global_position of the destroyed asteroid
signal destroyed(size: AsteroidSize, position: Vector2, velocity: Vector2, rotation: float)

enum AsteroidSize {
	SMALL,
	MEDIUM,
	LARGE,
}

const EXPLOSION_SIZES: Array[float] = [8, 16, 24]

## Size declared here should match Sprite
@export var size: AsteroidSize


## Emits destroyed signal, disables asteroid and displays explosion
func hit():
	collision_layer = 0
	collision_mask = 0
	$Sprite2D.hide()

	destroyed.emit(size, global_position, linear_velocity, angular_velocity)

	var explosion: CPUParticles2D = $Explosion
	explosion.emission_sphere_radius = EXPLOSION_SIZES[size]
	explosion.emitting = true
	await get_tree().create_timer(explosion.lifetime).timeout
	queue_free()
