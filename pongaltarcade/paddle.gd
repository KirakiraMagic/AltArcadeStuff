extends CharacterBody2D

@onready var collision_shape = $CollisionShape2D
@onready var color_rect = $ColorRect
const FIELD_WIDTH = 720.0
#const SPEED = 300.0
const DEFAULT_WIDTH = 100.0

var width = DEFAULT_WIDTH

var target_position = 0.0

func _ready():
	Global.vote_recived.connect(_on_vote_recived)
	#Determine paddle width
	width = FIELD_WIDTH / Global.connected_users
	width = clamp(width, DEFAULT_WIDTH, 360)
	collision_shape.shape.size.x = width
	color_rect.size.x = width
	color_rect.position.x = -width / 2
	position.x = width/2 - 360
	target_position = position.x


func _on_vote_recived(vote):
	if vote == 1:
		target_position += width
	if vote == -1:
		target_position -= width
	pass

	target_position = clamp(target_position, width/2 - 360, 360 - width/2)

func _physics_process(delta):
	position.x = lerp(position.x, target_position, 1.0 * delta)
	position.x = clamp(position.x, width/2 - 360, 360 - width/2)


#func _physics_process(delta):
#	if Input.is_action_pressed("ui_left"):
#		position.x -= SPEED * delta
#	if Input.is_action_pressed("ui_right"):
#		position.x += SPEED * delta
#		
#	position.x = clamp(position.x, -310, 310)

	
