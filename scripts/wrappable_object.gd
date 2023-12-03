class_name WrappableObject2D
extends Node2D
## Adds screen wrapping functionality to the parent `Node2D`.
##
## Must have a sibling `Sprite2D` to calculate the offset.
## This is implemented in `_physics_process`.

@onready var screen_size := get_viewport_rect().size
@onready var sprite = get_parent().get_node("Sprite2D")
## Adds half the sprite's (scaled) size to wrapping area so it's fully out of view before wrapping
@onready var wrap_offset: float = (sprite.get_rect().size.x / 2) * sprite.scale.x


func _physics_process(_delta):
	# wraps the projectile around the screen
	get_parent().transform.origin = Vector2(
		wrapf(get_parent().transform.origin.x, -wrap_offset, screen_size.x + wrap_offset),
		wrapf(get_parent().transform.origin.y, -wrap_offset, screen_size.y + wrap_offset)
	)
