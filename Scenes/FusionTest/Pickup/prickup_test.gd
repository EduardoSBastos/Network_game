extends Pickup

var collected := false


func collect(player: Player):
	Fusion.rpc_to(Fusion.TARGET_MASTER, _request_collect, player)

@rpc("any_peer")
func _request_collect(player: Player):
	if collected:
		return
	collected = true
	player.receive_score()
	Fusion.rpc(delete_me)

@rpc("any_peer", "call_local", "reliable")
func delete_me():
	return
	get_parent().queue_free()
