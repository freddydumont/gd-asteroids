class_name HUD
extends CanvasLayer


func update_score(score):
	$ScoreLabel.text = str(score)


func set_lives(lives_left: int):
	while $LivesContainer.get_child_count() > lives_left:
		$LivesContainer.get_child(0).free()
		
