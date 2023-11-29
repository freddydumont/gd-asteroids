class_name Game
extends Node2D

## how many lives the player has
@export var lives_left := 4
## how many asteroids should be spawned
@export var asteroid_spawn_count: int = 8
## a number of differently sized asteroid scenes
@export var asteroid_scenes: AsteroidScenes

var asteroid_current_count := 0
var score := 0
const asteroid_points := [100, 50, 20]


func _ready():
	$Player.take_damage.connect(_on_player_take_damage)


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


## Delays the asteroid spawns
func _on_asteroid_timer_timeout():
	if asteroid_current_count < asteroid_spawn_count:
		spawn_asteroid()
		asteroid_current_count += 1


func _on_start_timer_timeout():
	$AsteroidTimer.start()


func _on_player_take_damage():
	lives_left -= 1
	# TODO: if life reaches 0, game over
	$HUD.set_lives(lives_left)


func _on_asteroid_destroyed(
	size: Asteroid.AsteroidSize, destroyed_position: Vector2, velocity: Vector2, spin: float
):
	score += asteroid_points[size]
	$HUD.update_score(score)

	# TODO: add minimum velocity to child asteroids so they don't remain stationary
	for scene in asteroid_scenes.split(size):
		var asteroid = scene.instantiate()
		asteroid.position = destroyed_position
		asteroid.rotation += randf_range(-PI, PI)
		asteroid.linear_velocity = velocity.rotated(randf_range(-PI / 3, PI / 3)) * 1.25
		asteroid.angular_velocity = spin + randf_range(-PI / 3, PI / 3)
		asteroid.destroyed.connect(_on_asteroid_destroyed, CONNECT_ONE_SHOT)
		call_deferred("add_child", asteroid)
