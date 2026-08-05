extends Pickup

@onready var replicator:FusionReplicator = $"../FusionServerReplicator"

func collect(collector: Node):
	if collector is Player:
		# request destruction fusion
		Fusion.rpc(_get_collected(collector))

@rpc("any_peer", "call_local")
func _get_collected(collector: Node):
	collector.receive_score()
	#replicator.despawn(self)
