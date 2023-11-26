class_name Player
extends Entity

var projectile_scene := preload("res://scenes/projectile.tscn")

@export_group("Physics")
@export var thrust_force := 1200.0
@export var rotation_force := 1000

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


func _input(_event):
	# TODO: implement rate of fire
	if Input.is_action_pressed("fire"):
		shoot()


func shoot():
	var projectile: Projectile = projectile_scene.instantiate()

	projectile.global_position = $Gun.global_position
	projectile.rotation = self.rotation

	get_tree().current_scene.add_child(projectile)

	projectile.shoot()
