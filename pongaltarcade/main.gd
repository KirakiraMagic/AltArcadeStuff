extends Node2D

var spawned_field = false

@onready var game_field = preload("res://pong.tscn")
@onready var controller = preload("res://vote_controller.tscn")
@onready var start_text = $StartText

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.got_id.connect(_on_got_id)
	Global.reset_voting.connect(_on_reset_voting)

func _on_got_id():
	if Global.id >= 1:
		var controls = controller.instantiate()
		add_child(controls)

func _on_reset_voting():
	if not spawned_field and Global.id == 0:
		var pong = game_field.instantiate()
		add_child(pong)
		spawned_field = true
		
func _process(delta):
	start_text.text = str(Global.connected_users) + " Voters Registered \n" + str(Global.users_ready) + " / " + str(Global.connected_users) + " Voters Ready"
