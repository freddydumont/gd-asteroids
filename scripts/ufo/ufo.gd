class_name UFO
extends CharacterBody2D

signal destroyed

enum SpawnSide { LEFT, RIGHT }

## Y-axis offset to prevent spawn in corners
@export var spawn_offset: float = 120

@export_group("Movement")
@export var speed: float = 200.0
@export var change_time: float = 0.250
@export var max_angle_change: float = PI / 6

var time_since_last_change: float = 0.0
## Current direction as an angle
var current_angle: float

@onready var screen_size := get_viewport_rect().size


func _ready() -> void:
	spawn_ufo()


# TODO: shoot projectile at player at specified intervals
func _process(delta: float) -> void:
	time_since_last_change += delta

	# Slightly adjust the UFO's current angle randomly within the max_angle_change range
	if time_since_last_change >= change_time:
		time_since_last_change = 0.0
		current_angle += randf_range(-max_angle_change, max_angle_change)
		velocity = Vector2(cos(current_angle), sin(current_angle)).normalized() * speed

	# TODO: detect collisions with asteroids
	move_and_collide(velocity * delta)


func spawn_ufo() -> void:
	var spawn_position := Vector2.ZERO
	current_angle = randf_range(-PI / 4, PI / 4)

	# Set spawn position and calculate initial velocity based on the side
	match (randi() % 2) as SpawnSide:
		SpawnSide.LEFT:
			spawn_position.x = 0
		SpawnSide.RIGHT:
			spawn_position.x = screen_size.x
			current_angle = PI - current_angle

	velocity = Vector2(cos(current_angle), sin(current_angle)).normalized() * speed

	# random position along the y axis, with offset to prevent spawn in the corners
	spawn_position.y = randf_range(spawn_offset, screen_size.y - spawn_offset)

	global_position = spawn_position


func hit():
	collision_layer = 0
	collision_mask = 0
	$Sprite2D.hide()

	destroyed.emit()
	# TODO: drop powerup

	var explosion: CPUParticles2D = $Explosion
	explosion.emitting = true
	await get_tree().create_timer(explosion.lifetime).timeout
	queue_free()
