extends CharacterBody2D

@onready var ball = $"../Ball"
const SPEED = 200.0
const FEILD_HEIGHT = 720
const PADDLE_WIDTH = 100

func _physics_process(delta):
	
	if ball.forward.y > 0:
		return

	if abs(ball.position.x - position.x)  < PADDLE_WIDTH/2:
		return
	
	if ball.position.x < position.x:
		position.x -= SPEED * delta
	elif ball.position.x > position.x:
		position.x += SPEED * delta
	
	position.x = clamp(position.x, -310, 310)
