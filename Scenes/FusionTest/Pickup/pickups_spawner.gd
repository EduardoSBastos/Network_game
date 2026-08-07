extends Node3D
class_name PickupSpawner

@onready var spawner: FusionSpawner = $"../FusionSpawner - Pickups"


func _ready():
	Fusion.room_joined.connect(_on_room_joined)
	print("Spawner replicator:", spawner.get_parent())

func _on_room_joined():
	if not Fusion.is_master_client():
		return
	_spawn_pickup()

func _spawn_pickup():
	print(
		"================ Spawning pickup on peer ", Fusion.get_local_player_id(),
		" master=", Fusion.is_master_client(),
	)
	var pickup = spawner.spawn()
