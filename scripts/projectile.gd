class_name Projectile
extends Area2D

@export var damage: int = 2
@export var speed: float = 300


func _on_body_entered(body: Node2D):
	if body.has_method("hit"):
		body.hit(damage)

	# disappear for now
	# TODO: hit sprites animation
	self.queue_free()
