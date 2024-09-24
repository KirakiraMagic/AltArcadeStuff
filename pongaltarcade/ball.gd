extends CharacterBody2D

const PADDLE2_WIDTH: float = 100.0
@onready var paddle1 = $"../Paddle1"
@export var speed : float = 300.0
var forward = Vector2(1.0,-1.0).normalized()


func _physics_process(delta) -> void:
	Engine.time_scale = lerp(Engine.time_scale, 1.0, 0.1) 
	var collision: KinematicCollision2D = move_and_collide(forward * speed * delta)
	if collision:
		$"../BounceSfxAudio".play(0.0)
		screen_shake()
		forward = forward.bounce(collision.get_normal())
		if collision.get_collider().is_in_group("paddle1"):
			Engine.time_scale = 2.0
			var paddle_x = collision.get_collider().position.x - paddle1.width/2
			var pos_on_paddle = (position.x - paddle_x) / paddle1.width
			var bounce_angle = lerp(PI * -0.8, PI * -0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			Global.restart_vote()
		elif collision.get_collider().is_in_group("paddle2"):
			Engine.time_scale = 2.0
			var paddle_x = collision.get_collider().position.x - PADDLE2_WIDTH/2
			var pos_on_paddle = (position.x - paddle_x) / PADDLE2_WIDTH
			var bounce_angle = lerp(PI * 0.8, PI * 0.2, pos_on_paddle)
			forward = Vector2.from_angle(bounce_angle)
			
func screen_shake():
	#screen shake with tweens
	var camera = get_viewport().get_camera_2d()
	var tween = create_tween()
	tween.tween_property(camera, "offset", -forward * 10, 0.1)
	tween.tween_property(camera, "offset", Vector2(0, 0), 0.1)
