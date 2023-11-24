class_name Game
extends Node2D

## how many asteroids should be spawned
@export var asteroid_spawn_count: int = 8
## a number of different asteroid scenes
@export var asteroid_scenes: Array[PackedScene]

var asteroid_current_count := 0


# adapted from: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/05.the_main_game_scene.html
func spawn_asteroid():
	var asteroid: Asteroid = asteroid_scenes.pick_random().instantiate()

	# Choose a random location on Path2D.
	var asteroid_spawn_location: PathFollow2D = $AsteroidPath/AsteroidSpawnLocation
	asteroid_spawn_location.progress_ratio = randf()

	# Set the asteroid's direction perpendicular to the path direction, with some randomness
	var direction = asteroid_spawn_location.rotation + PI / 2 + randf_range(-PI / 4, PI / 4)

	asteroid.position = asteroid_spawn_location.position
	asteroid.rotation = direction

	# Launch the asteroid
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	asteroid.linear_velocity = velocity.rotated(direction)
	asteroid.angular_velocity = randf_range(-4, 4)
	add_child(asteroid)


## Delays the asteroid spawns
func _on_asteroid_timer_timeout():
	if asteroid_current_count < asteroid_spawn_count:
		spawn_asteroid()
		asteroid_current_count += 1


func _on_start_timer_timeout():
	$AsteroidTimer.start()
