extends Area3D
class_name Pickup

func _ready():
	print(
		"VVVVVVVVVVVVVVVVVV:  ",
		"Pickup ready on peer ",
		Fusion.get_local_player_id()
	)

func collect(collector:Player):
	pass
