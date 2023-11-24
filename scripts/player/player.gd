class_name Player
extends RigidBody2D

@export_group("Physics")
@export var thrust_force := 1200.0
@export var rotation_force := 1000

var thrust := Vector2.ZERO
var rotation_dir := 0.0

@onready var screen_size := get_viewport_rect().size
## Adds half the ship's (scaled) size to wrapping area so it's fully out of view before wrapping
@onready var wrap_offset: float = ($Sprite2D.get_rect().size.x / 2) * $Sprite2D.scale.x


func _ready():
	# place the player at the center of the screen
	position = screen_size / 2


# Movement and wrapping adapted from:
# https://kidscancode.org/godot_recipes/4.x/physics/asteroids_physics/index.html
func _physics_process(_delta):
	thrust = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		thrust = transform.x * thrust_force

	rotation_dir = Input.get_axis("ui_left", "ui_right")

	constant_force = thrust
	constant_torque = rotation_dir * rotation_force


## TODO: extract that to an entity class which is inherited by both player and asteroids
func _integrate_forces(state: PhysicsDirectBodyState2D):
	# Wrap to other side when reaching end of screen
	state.transform.origin = Vector2(
		wrapf(state.transform.origin.x, -wrap_offset, screen_size.x + wrap_offset),
		wrapf(state.transform.origin.y, -wrap_offset, screen_size.y + wrap_offset)
	)
