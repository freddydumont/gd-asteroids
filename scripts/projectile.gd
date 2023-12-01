class_name Projectile
extends Area2D

@export var speed: float = 1000
@export var lifetime: float = 1

var linear_velocity: Vector2 = Vector2.ZERO

@onready var screen_size := get_viewport_rect().size
## Adds half the sprite's (scaled) size to wrapping area so it's fully out of view before wrapping
@onready var wrap_offset: float = ($Sprite2D.get_rect().size.x / 2) * $Sprite2D.scale.x


func _ready():
	# if the projectile doesn't hit, it disappears after its lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _physics_process(delta: float):
	position += linear_velocity * delta

	# wraps the projectile around the screen
	transform.origin = Vector2(
		wrapf(transform.origin.x, -wrap_offset, screen_size.x + wrap_offset),
		wrapf(transform.origin.y, -wrap_offset, screen_size.y + wrap_offset)
	)


func shoot():
	var direction := Vector2(cos(rotation), sin(rotation))
	linear_velocity = direction * speed


## triggers the hit() method when a collision is detected
func _on_body_entered(body: Node2D):
	if body.has_method("hit"):
		body.hit()

	if not (body is Player):
		await play_hit_animation()
		queue_free()


## Plays an hit animation and returns `animation_finished` signal
func play_hit_animation() -> Signal:
	# disable sprite, movement and collision
	$Sprite2D.hide()
	linear_velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)

	# play animation
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("hit")
	return $AnimatedSprite2D.animation_finished
