class_name AsteroidSpawner
extends Node2D

signal score_updated(points: int)
signal level_completed

const ASTEROID_POINTS := [100, 50, 20]

## a number of differently sized asteroid scenes
@export var asteroid_scenes: AsteroidScenes
## how many asteroids should be spawned
@export var asteroid_spawn_count: int = 4
## how many more asteroids per level
@export var asteroid_level_increment: int = 4

var asteroid_current_count := 0


# adapted from: https://docs.godotengine.org/en/stable/getting_started/first_2d_game/05.the_main_game_scene.html
func spawn_asteroid():
	var asteroid: Asteroid = asteroid_scenes.random().instantiate()
	# connect instance signal to game
	asteroid.destroyed.connect(_on_asteroid_destroyed, CONNECT_ONE_SHOT)

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


func _on_game_start_timer_timeout():
	$AsteroidTimer.start()


## Delays the asteroid spawns
func _on_asteroid_timer_timeout():
	if asteroid_current_count < asteroid_spawn_count:
		spawn_asteroid()
		asteroid_current_count += 1
	else:
		$AsteroidTimer.stop()


## Updates score and replace destroyed asteroid with two of smaller size
func _on_asteroid_destroyed(
	size: Asteroid.AsteroidSize, destroyed_position: Vector2, velocity: Vector2, spin: float
):
	score_updated.emit(ASTEROID_POINTS[size])

	# TODO: add minimum velocity to child asteroids so they don't remain stationary
	for scene in asteroid_scenes.split(size):
		var asteroid = scene.instantiate()
		asteroid.position = destroyed_position
		asteroid.rotation += randf_range(-PI, PI)
		asteroid.linear_velocity = velocity.rotated(randf_range(-PI / 3, PI / 3)) * 1.25
		asteroid.angular_velocity = spin + randf_range(-PI / 3, PI / 3)
		asteroid.destroyed.connect(_on_asteroid_destroyed, CONNECT_ONE_SHOT)
		asteroid_current_count += 1
		call_deferred("add_child", asteroid)

	asteroid_current_count -= 1

	if asteroid_current_count == 0:
		level_completed.emit()


func _on_level_completed():
	asteroid_spawn_count += asteroid_level_increment
