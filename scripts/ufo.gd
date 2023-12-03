class_name UFO
extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 120.0
@export var change_time: float = 2.0

var time_since_last_change: float = 0.0


func _process(delta: float) -> void:
	# Randomize movement every `change_time` seconds
	time_since_last_change += delta
	if time_since_last_change >= change_time:
		time_since_last_change = 0.0
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

	# Move the UFO
	move_and_slide()
