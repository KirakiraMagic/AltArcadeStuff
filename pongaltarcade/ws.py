import os
import asyncio
import websockets
import json

connected_users = []
next_player_id = 0
host_websocket = None

async def on_connect(websocket, path):
    global connected_users, next_player_id, host_websocket
    connected_users.append(websocket)
    if next_player_id == 0:
        host_websocket = websocket
    await websocket.send(json.dumps({ "name" : "player_info", "player_id" : next_player_id}))
    await host_websocket.send(json.dumps({"name" : "game_info", "num_players" : len(connected_users) - 1}))
    next_player_id += 1
    print(f"New connection from {websocket.remote_address}")
    
async def on_disconnect(websocket, path):
    global connected_users, host_websocket
    if websocket == host_websocket:
        await reset_server()
    if websocket in connected_users:
        connected_users.remove(websocket)
        print(f"Disconnected from {websocket.remote_address}")
    
async def reset_server():
    global connected_users, next_player_id, host_websocket
    # Close all active connections
    for user in connected_users:
        await user.close()
    # Reset state variables
    connected_users = []
    next_player_id = 0
    host_websocket = None
    print("Server has been reset")
    
# Define a callback function to handle incoming WebSocket messages
async def handle_websocket(websocket, path):
    global connected_users, host_websocket
    await on_connect(websocket, path)
    try:
        while True:
            message = await websocket.recv()
            print(f"Received message: >{message}<")
            data = json.loads(message)
            
            match data["name"]:
                case "vote":
                    await host_websocket.send(message)
                case "start_voting":
                    for user in connected_users:
                        await user.send(message)
                    
    except websockets.ConnectionClosed:
        await on_disconnect(websocket, path)

if __name__ == "__main__":
    
    # Start the WebSocket server
    start_server = websockets.serve(handle_websocket, "localhost", 5000)

    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()