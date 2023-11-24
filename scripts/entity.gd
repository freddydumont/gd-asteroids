class_name Entity
extends RigidBody2D

@onready var screen_size := get_viewport_rect().size
## Adds half the sprite's (scaled) size to wrapping area so it's fully out of view before wrapping
@onready var wrap_offset: float = ($Sprite2D.get_rect().size.x / 2) * $Sprite2D.scale.x


func _integrate_forces(state: PhysicsDirectBodyState2D):
	# Wrap to other side when reaching end of screen
	state.transform.origin = Vector2(
		wrapf(state.transform.origin.x, -wrap_offset, screen_size.x + wrap_offset),
		wrapf(state.transform.origin.y, -wrap_offset, screen_size.y + wrap_offset)
	)
