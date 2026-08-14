extends Node3D

const CharacterScene = preload("res://Scenes/FusionTest/authority_character_3d.tscn")

@onready var spawner: FusionSpawner = $"FusionSpawner - Players"

func _ready():
	
	Fusion.room_joined.connect(_on_room_joined)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	spawner.add_spawnable_scene(CharacterScene)

	Fusion.connect_to_photon.call_deferred("user_%d" % randi())
	Fusion.connected_to_photon.connect(func():
		var rooms: Array[FusionRoomListing] = Fusion.get_room_list()
		for room in rooms:
			print("===============================================")
			print(room.name)
			print(room.player_count)
		var options := FusionRoomOptions.new()
		options.max_players = 8
		options.is_visible = true
		Fusion.join_or_create_room(
			"test_%d" % Time.get_unix_time_from_system(),
			options
			)
	)

func _on_room_joined():
	if Fusion.is_master_client():
		_spawn_character(Fusion.get_local_player_id())
	else:
		Fusion.rpc(request_spawn)

@rpc("any_peer", "call_local")
func request_spawn():
	if not Fusion.is_master_client():
		return
	var sender_id = Fusion.get_rpc_sender()
	_spawn_character(sender_id)

func _spawn_character(player_id: int):
	print(
		"================ Spawning on peer ", Fusion.get_local_player_id(),
		" master=", Fusion.is_master_client(),
		" for player=", player_id
	)
	var character = spawner.spawn()
	character.position = Vector3(randf_range(-2, 2), 1.0, randf_range(-2, 2))
	character.get_node("FusionServerReplicator").set_input_authority(player_id)
	
	
	
	
	
	
	
