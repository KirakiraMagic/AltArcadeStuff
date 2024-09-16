extends Node2D

@onready var restart_timer = $RestartTimer
@onready var score_label = $ScoreLabel
@onready var ball = $Ball
@onready var win_label = $WinLabel

var p1_score = 0
var p2_score = 0

func _process(delta):
	#Updates the score UI
	score_label.text = str(p2_score) + "\n\n" + str(p1_score)

#The ball enters the goal behind p1
func _on_goal_p1_body_entered(body):
	print("hello")
	if body.is_in_group("ball"):
		p2_score += 1
		if check_finish() == false:
			Global.restart_vote()
			restart_timer.start()

#The ball enters the goal behind p2
func _on_goal_p2_body_entered(body):
	print("hello")
	if body.is_in_group("ball"):
		p1_score += 1
		if check_finish() == false:
			Global.restart_vote()
			restart_timer.start()

func _on_restart_timer_timeout():
	ball.position = Vector2(-300.0, 0.0)
	ball.forward = Vector2(1.0,sign(ball.forward.y)).normalized()

func check_finish() -> bool:
	if (p1_score >= 11) and (p1_score - p2_score >= 2):
		win_label.text = "Player 1 Wins! \n Reload to play again."
		return true
	if (p2_score >= 11) and (p2_score - p1_score >= 2):
		win_label.text = "Player 2 Wins! \n Reload to play again."
		return true
	return false