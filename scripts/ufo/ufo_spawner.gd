class_name UFOSpawner
extends Node2D
## Spawns a UFO every `$UFOTimer.wait_time` seconds.
## TODO: prevent spawn between levels

@export var spawn_after_seconds: float = 4

var ufo_scene := preload("res://scenes/ufo.tscn")
var level := 1


func _on_ufo_timer_timeout():
	var ufo := ufo_scene.instantiate()
	ufo.destroyed.connect(_on_ufo_destroyed, CONNECT_ONE_SHOT)
	ufo.destroyed.connect(get_parent()._on_ufo_destroyed, CONNECT_ONE_SHOT)
	add_child(ufo)


func _on_game_level_started(game_level: int):
	level = game_level
	start_ufo_timer()


func _on_ufo_destroyed(_points: int):
	start_ufo_timer()


func start_ufo_timer():
	$UFOTimer.wait_time = spawn_after_seconds / level
	$UFOTimer.start()
