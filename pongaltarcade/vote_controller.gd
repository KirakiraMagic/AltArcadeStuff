extends Node2D

@onready var right_button = $Right
@onready var left_button = $Left
@onready var ready_button = $Ready

var has_voted = false

func _ready():
	Global.reset_voting.connect(_on_reset_voting)

func _on_reset_voting():
	has_voted = false
	buttons_visibility(true)

func _on_right_pressed():
	if has_voted == false:
		has_voted = true
		Global.send_vote(1)
		buttons_visibility(false)

func _on_left_pressed():
	if has_voted == false:
		has_voted = true
		Global.send_vote(-1)
		buttons_visibility(false)

func _on_ready_pressed():
	ready_button.visible = false
	has_voted = true
	Global.send_vote(2)

func buttons_visibility(can_see: bool):
	right_button.visible = can_see
	left_button.visible = can_see
