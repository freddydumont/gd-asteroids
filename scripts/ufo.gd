class_name UFO
extends CharacterBody2D

enum SpawnSide { LEFT, RIGHT }

## Y-axis offset to prevent spawn in corners
@export var spawn_offset: float = 120

@export_group("Movement")
@export var speed: float = 120.0
@export var change_time: float = 2.0

var time_since_last_change: float = 0.0

@onready var screen_size := get_viewport_rect().size


func _init() -> void:
	spawn_ufo()


func _process(delta: float) -> void:
	# Randomize movement every `change_time` seconds
	time_since_last_change += delta
	if time_since_last_change >= change_time:
		time_since_last_change = 0.0
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

	# Move the UFO
	move_and_slide()


func spawn_ufo() -> void:
	var spawn_side := randi() % 2 as SpawnSide
	var spawn_position := Vector2.ZERO
	var direction_angle := randf_range(-PI / 4, PI / 4)

	# Set spawn position and calculate initial velocity based on the side
	match spawn_side:
		SpawnSide.LEFT:
			spawn_position.x = 0
			velocity = Vector2(cos(direction_angle), sin(direction_angle)).normalized() * speed
		SpawnSide.RIGHT:
			spawn_position.x = screen_size.x
			velocity = Vector2(-cos(direction_angle), sin(direction_angle)).normalized() * speed

	# random position along the y axis, with offset to prevent spawn in the corners
	spawn_position.y = randf_range(spawn_offset, screen_size.y - spawn_offset)

	global_position = spawn_position
