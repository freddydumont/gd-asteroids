class_name Player
extends RigidBody2D

@export_group("Physics")
@export var thrust_force := 1500.0
@export var rotation_force := 1000

@onready var screen_size := get_viewport_rect().size
@onready var thruster: Sprite2D = $Sprite2D/Thruster
@onready var initial_position_y := thruster.position.y
@onready var initial_scale_y := thruster.scale.y
@onready var final_position_y := 88.0
@onready var final_scale_y := 1.0

enum ThrusterState { IDLE, ENGAGING, ENGAGED, DISENGAGING }

var thrust := Vector2.ZERO
var rotation_dir := 0.0

var tween: Tween
var animation_state := ThrusterState.IDLE
var animation_duration: float = 0.400


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


func _integrate_forces(state: PhysicsDirectBodyState2D):
	## Adds half the ship's size to wrapping area so it's fully out of view before wrapping
	var offset: float = $Sprite2D.get_rect().size.x / 2

	# Wrap to other side when reaching end of screen
	state.transform.origin = Vector2(
		wrapf(state.transform.origin.x, -offset, screen_size.x + offset),
		wrapf(state.transform.origin.y, -offset, screen_size.y + offset)
	)


func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		match animation_state:
			ThrusterState.IDLE:
				animate_thruster()
			ThrusterState.DISENGAGING:
				tween.kill()
				animate_thruster()
	elif Input.is_action_just_released("ui_up"):
		match animation_state:
			ThrusterState.ENGAGING:
				tween.kill()
				animate_thruster(true)
			ThrusterState.ENGAGED:
				animate_thruster(true)


## Thruster animation is a single texture that's scaled and moved
## to simulate the engine's increasing power. It's tweened back to
## initial values instead of cutting off instantly.
func animate_thruster(reset: bool = false):
	tween = create_tween()
	tween.set_parallel()
	tween.connect("finished", _on_Tween_tween_completed)
	if reset:
		tween.tween_property(thruster, "position:y", initial_position_y, animation_duration)
		tween.tween_property(thruster, "scale:y", initial_scale_y, animation_duration)
		animation_state = ThrusterState.DISENGAGING
	else:
		tween.tween_property(thruster, "position:y", final_position_y, animation_duration)
		tween.tween_property(thruster, "scale:y", final_scale_y, animation_duration)
		animation_state = ThrusterState.ENGAGING


func _on_Tween_tween_completed():
	match animation_state:
		ThrusterState.ENGAGING:
			animation_state = ThrusterState.ENGAGED
		ThrusterState.DISENGAGING:
			animation_state = ThrusterState.IDLE
