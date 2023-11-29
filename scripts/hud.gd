class_name HUD
extends CanvasLayer


func update_score(score):
	$ScoreLabel.text = str(score)


func set_lives(lives_left: int):
	$LivesContainer.get_child(lives_left).hide()
