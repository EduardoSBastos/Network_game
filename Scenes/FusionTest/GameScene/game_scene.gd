extends Node2D

const CharacterScene = preload("uid://dw36jg7i185k")

@export var spawner: FusionSpawner


func _ready():
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	
	spawner.add_spawnable_scene(CharacterScene)
	
	# wait 3s to spawn
	get_tree().create_timer(1.0).timeout.connect(spawn_players)


func spawn_players():
	if Fusion.is_master_client():
		_spawn_character(Fusion.get_local_player_id())
	else:
		Fusion.rpc(request_spawn)


@rpc("any_peer", "call_local")
func request_spawn():
	if not Fusion.is_master_client():
		return
	var sender_id = Fusion.get_rpc_sender()
	print("Creating character for player ", sender_id)
	_spawn_character(sender_id)


func _spawn_character(player_id: int):
	var character = spawner.spawn()
	character.position = Vector2(randf_range(100, 500), randf_range(50, 250))
	character.get_node("FusionServerReplicator").set_input_authority(player_id)
