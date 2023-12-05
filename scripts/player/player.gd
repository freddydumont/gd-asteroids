class_name Player
extends WrappableRigidBody2D

signal take_damage

@export_group("Health")
## how much time in seconds the player is invulnerable after a hit
@export var invulnerability_seconds := 3.0

@export_group("Physics")
@export var thrust_force := 1200.0
@export var rotation_force := 1000

@export_group("Gun")
## fire rate in seconds (e.g., 0.5 seconds between shots)
@export var fire_rate: float = 0.5

var projectile_scene := preload("res://scenes/projectile.tscn")

var time_since_invulnerable := 0.0
var is_invulnerable := false

var time_since_last_shot: float = 0.0
var is_on_cooldown: bool = false

var thrust := Vector2.ZERO
var rotation_dir := 0.0

@onready var thrust_audio: AudioStreamPlayer = $Thrust


func _ready():
	# place the player at the center of the screen
	position = screen_size / 2


func _integrate_forces(state: PhysicsDirectBodyState2D):
	# this calls WrappableRigidBody2D's same func that allows wrapping around screen
	super(state)

	if (
		not is_invulnerable
		and state.get_contact_count() > 0
		and state.get_contact_collider_object(0).collision_layer == self.collision_mask
	):
		take_damage.emit()
		is_invulnerable = true


# Movement and wrapping adapted from:
# https://kidscancode.org/godot_recipes/4.x/physics/asteroids_physics/index.html
func _physics_process(_delta):
	thrust = Vector2.ZERO

	if Input.is_action_pressed("thrust"):
		thrust = transform.x * thrust_force
		thrust_audio.play()

	if Input.is_action_just_released("thrust"):
		await get_tree().create_timer(0.2).timeout
		thrust_audio.stop()

	rotation_dir = Input.get_axis("rotate_left", "rotate_right")

	constant_force = thrust
	constant_torque = rotation_dir * rotation_force


func _process(delta: float):
	# play invulnerability animation and reset invulnerability
	if is_invulnerable:
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("invulnerability")
			$ShieldUp.play()

		time_since_invulnerable += delta
		if time_since_invulnerable >= invulnerability_seconds:
			is_invulnerable = false
			$AnimationPlayer.stop()
			$ShieldDown.play()
			time_since_invulnerable = 0.0

	# If we're on cooldown, update the time since the last shot fired
	if is_on_cooldown:
		time_since_last_shot += delta
		# Check if we're ready to fire again
		if time_since_last_shot >= fire_rate:
			is_on_cooldown = false
			time_since_last_shot = 0.0

	if Input.is_action_pressed("fire") and not is_on_cooldown:
		shoot()
		is_on_cooldown = true


func shoot():
	var projectile: Projectile = projectile_scene.instantiate()

	projectile.global_position = $Gun.global_position
	projectile.rotation = self.rotation

	get_tree().current_scene.add_child(projectile)

	projectile.shoot()
	$Zap.play()


## Disables controls, hides the ship and displays explosion before freeing
func _on_game_game_over():
	set_process(false)
	set_physics_process(false)
	$Sprite2D.hide()

	$ShipDestroyed.play()
	var explosion: CPUParticles2D = $Explosion
	explosion.emitting = true
	await get_tree().create_timer(explosion.lifetime).timeout
	queue_free()


## when hit by something other than asteroids
func hit():
	if not is_invulnerable:
		take_damage.emit()
		is_invulnerable = true
