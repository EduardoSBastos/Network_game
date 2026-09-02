extends Node2D

const character_scene = preload("uid://dw36jg7i185k")

@export var spawner: FusionSpawner
@export var spawn_points:Array[Node]

func _ready():
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	spawner.add_spawnable_scene(character_scene)
	# wait 3s to spawn
	get_tree().create_timer(2.0).timeout.connect(spawn_players)


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
	_spawn_character(sender_id)


func _spawn_character(player_id: int):
	var character:CharacterBody2D = spawner.spawn()
	var replicator: FusionServerReplicator = character.get_node("FusionServerReplicator")
	replicator.set_input_authority(player_id)
	
	var spawn_position = spawn_points[player_id-1].position
	character.position = spawn_position
