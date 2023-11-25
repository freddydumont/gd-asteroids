class_name PlayerAnimations
extends Sprite2D

enum ThrusterState { IDLE, ENGAGING, ENGAGED, DISENGAGING }

@export_group("Animation")
@export var animation_duration: float = 0.400

var tween: Tween
var animation_state := ThrusterState.IDLE

@onready var screen_size := get_viewport_rect().size
@onready var thruster: Sprite2D = $Thruster
@onready var initial_position_y := thruster.position.y
@onready var initial_scale_y := thruster.scale.y
@onready var final_position_y := 88.0
@onready var final_scale_y := 1.0


func _input(_event):
	if Input.is_action_just_pressed("thrust"):
		match animation_state:
			ThrusterState.IDLE:
				animate_thruster()
			ThrusterState.DISENGAGING:
				tween.kill()
				animate_thruster()
	elif Input.is_action_just_released("thrust"):
		match animation_state:
			ThrusterState.ENGAGING:
				tween.kill()
				animate_thruster(true)
			ThrusterState.ENGAGED:
				animate_thruster(true)

	# lateral thrusters
	if Input.is_action_just_pressed("rotate_right"):
		$LateralThrusterLeft.emitting = true
	elif Input.is_action_just_released("rotate_right"):
		$LateralThrusterLeft.emitting = false
	if Input.is_action_just_pressed("rotate_left"):
		$LateralThrusterRight.emitting = true
	elif Input.is_action_just_released("rotate_left"):
		$LateralThrusterRight.emitting = false


## Thruster animation is a single texture that's scaled and moved
## to simulate the engine's increasing power. It's tweened back to
## initial values instead of cutting off instantly.
func animate_thruster(reset: bool = false):
	tween = create_tween()
	tween.set_parallel()
	tween.connect("finished", _on_Tween_tween_completed)
	if reset:
		tween.tween_property(thruster, "position:y", initial_position_y, animation_duration * 2)
		tween.tween_property(thruster, "scale:y", initial_scale_y, animation_duration * 2)
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
