class_name Game
extends Node2D

signal game_over

## how many lives the player has
@export var lives_left := 4

var score := 0
var level := 1


func _ready():
	$HUD.set_lives(lives_left)
	$Player.take_damage.connect(_on_player_take_damage)
	$AsteroidSpawner.level_completed.connect(_on_asteroid_spawner_level_completed)
	$AsteroidSpawner.score_updated.connect(_on_asteroid_spawner_score_updated)


func _on_start_timer_timeout():
	$HUD/Messages/Label.hide()


func _on_player_take_damage():
	lives_left -= 1
	$HUD.set_lives(lives_left)

	if lives_left == 0:
		game_over.emit()


## Displays Game Over message for 3 secs, then start countdown to reset
func _on_game_over():
	$HUD/Messages/Label.text = "Game Over"
	$HUD/Messages/Label.show()
	await get_tree().create_timer(3).timeout

	await (await message_timer("Resetting")).timeout
	get_tree().reload_current_scene()


func _on_asteroid_spawner_score_updated(points: int):
	score += points
	$HUD.update_score(score)


func _on_ufo_destroyed(points: int):
	score += points
	$HUD.update_score(score)


func _on_asteroid_spawner_level_completed():
	$HUD/Messages/Label.text = "Level %s complete!" % level
	$HUD/Messages/Label.show()
	await get_tree().create_timer(3).timeout

	await (await message_timer("Next level")).timeout
	$StartTimer.wait_time = 0.1

	level += 1
	$StartTimer.start()


## Displays a 3 sec countdown message and returns a signal to await for
func message_timer(message: String) -> SceneTreeTimer:
	$HUD/Messages/Label.text = "%s in 3..." % message
	await get_tree().create_timer(1).timeout
	$HUD/Messages/Label.text = "%s in 2..." % message
	await get_tree().create_timer(1).timeout
	$HUD/Messages/Label.text = "%s in 1..." % message
	return get_tree().create_timer(1)
