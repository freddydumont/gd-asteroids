class_name Player
extends Entity

var projectile_scene := preload("res://scenes/projectile.tscn")

@export_group("Physics")
@export var thrust_force := 1200.0
@export var rotation_force := 1000

@export_group("Gun")
## fire rate in seconds (e.g., 0.5 seconds between shots)
@export var fire_rate: float = 0.5

var time_since_last_shot: float = 0.0
var is_on_cooldown: bool = false

var thrust := Vector2.ZERO
var rotation_dir := 0.0


func _ready():
	# place the player at the center of the screen
	position = screen_size / 2


# Movement and wrapping adapted from:
# https://kidscancode.org/godot_recipes/4.x/physics/asteroids_physics/index.html
func _physics_process(_delta):
	thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		thrust = transform.x * thrust_force

	rotation_dir = Input.get_axis("rotate_left", "rotate_right")

	constant_force = thrust
	constant_torque = rotation_dir * rotation_force


func _process(delta: float):
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


# TODO: implement this in entity.gd
# impulse should determine the amount of damage received
# or if the asteroid will be destroyed on impact
func _integrate_forces(state: PhysicsDirectBodyState2D):
	var contact_count: int = state.get_contact_count()
	for i in range(contact_count):
		var collision: Dictionary = {
			"collider": state.get_contact_collider(i),
			"point": state.get_contact_local_position(i),
			"normal": state.get_contact_local_normal(i),
			"impulse": state.get_contact_impulse(i)
		}

		if collision.impulse > Vector2.ZERO:
			print("Collision %s:" % i, collision)
