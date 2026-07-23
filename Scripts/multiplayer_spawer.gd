extends MultiplayerSpawner

@export var network_player: PackedScene

var current_player: Node = null

var next_position:int = 0

func _ready() -> void:
	spawn_function = _spawn_player
	Lobby.all_players_loaded.connect(spawn_all_players)
	Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

func spawn_all_players():
	print("Spawning Players")
	if multiplayer.is_server():
		for player_id in Lobby.players:
			var data = {"id": player_id, "position": Vector2(150,150)}
			spawn(data)

func _spawn_player(data:Dictionary) -> CharacterBody2D:
	var player: CharacterBody2D = network_player.instantiate()
	player.initialize(data["id"], data["position"])
	return player
