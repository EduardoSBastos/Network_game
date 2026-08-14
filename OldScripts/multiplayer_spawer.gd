extends MultiplayerSpawner

@export var network_player: PackedScene
@export var start_positions:Array[Node2D]

var current_player: Node = null

func _ready() -> void:
	spawn_function = _spawn_player
	Lobby.all_players_loaded.connect(spawn_all_players)
	Lobby.player_loaded.rpc_id(1) # Tell the server that this peer has loaded.

func spawn_all_players():
	print("Spawning Players")
	if multiplayer.is_server():
		var player_numer = 0
		for player_id in Lobby.players:
			var start_position: Vector2 = start_positions[player_numer].position
			player_numer += 1
			var data = {"id": player_id, "position": start_position}
			spawn(data)

func _spawn_player(data:Dictionary) -> CharacterBody2D:
	var player: CharacterBody2D = network_player.instantiate()
	player.initialize(data["id"], data["position"])
	return player
