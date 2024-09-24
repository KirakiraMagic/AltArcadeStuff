extends Node

## Player ID. ID of 0 is the host of the pong game
var id := -1
## Number of connected users
var connected_users := 0
## Number of users that are ready to play
var users_ready := 0
var game_started := false

signal vote_recived(vote: int)
signal reset_voting()
signal got_id()

# The URL we will connect to.
var websocket_url = "wss://c-98-43-186-44.hsd1.co.comcast.net:5000"
#var websocket_url = "ws://localhost:5000"
var socket := WebSocketPeer.new()

func _ready():
	if socket.connect_to_url(websocket_url) != OK:
		print("Could not connect.")
		set_process(false)
	else:
		print("Connected to server" + websocket_url)

func _process(_delta):
	socket.poll()
	
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var result = JSON.parse_string(socket.get_packet().get_string_from_utf8())
			print(result)
			
			match result["name"]:
				"player_info":
					id = result["player_id"]
					got_id.emit()

				"game_info":
					connected_users = result["num_players"]
				
				"vote":
					if result["direction"] == 2:
						users_ready += 1
						if users_ready == connected_users:
							game_started = true
							restart_vote()
					else:
						vote_recived.emit(result["direction"])
				
				"start_voting":
					reset_voting.emit()

func _exit_tree():
	socket.close()

func send_vote(vote: int):
	socket.send_text(JSON.stringify({
		"name" : "vote",
		"player_id" : id,
		"direction" : vote,
	}))

func restart_vote():
	socket.send_text(JSON.stringify({
		"name" : "start_voting",
	}))
