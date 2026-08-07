extends Node3D
class_name PickupSpawner

@onready var spawner: FusionSpawner = $"FusionSpawner - Pickups"


func _ready():
	Fusion.room_joined.connect(_spawn_pickup)
	# _spawn_pickup.call_deferred()

func _spawn_pickup():
	print(
		"================ Spawning on peer ", Fusion.get_local_player_id(),
		" master=", Fusion.is_master_client(),
	)
	var character = spawner.spawn()
