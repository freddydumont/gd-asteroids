class_name UFOSpawner
extends Node2D
## Spawns a UFO every `$UFOTimer.wait_time` seconds.
## TODO: seconds are divided by level (get from game timer signal)
## TODO: ufo timer should start only when prev ufo is detroyed
## TODO: increment score when UFO is destroyed

@export var spawn_after_seconds: float = 4

var ufo := preload("res://scenes/ufo.tscn")


## Starts the ufo timer countdown when game starts
func _on_game_start_timer_timeout():
	start_ufo_timer()


func _on_ufo_timer_timeout():
	add_child(ufo.instantiate())


func start_ufo_timer():
	$UFOTimer.wait_time = spawn_after_seconds
	$UFOTimer.start()