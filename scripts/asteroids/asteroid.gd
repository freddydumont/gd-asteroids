class_name Asteroid
extends Entity


func hit(damage: int):
	# TODO: change sound based on asteroid size
	# this sound is for big asteroids, who'll split into smaller ones
	$Split.play()
	print("ouch ", damage)
