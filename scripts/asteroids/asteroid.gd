class_name Asteroid
extends Entity

enum AsteroidSize {
	SMALL,
	MEDIUM,
	LARGE,
}

## Size declared here should match Sprite
@export var size: AsteroidSize


func hit(_damage: int):
	# TODO: change sound based on asteroid size
	# this sound is for big asteroids, who'll split into smaller ones
	$Split.play()
	print("ouch ", size)
