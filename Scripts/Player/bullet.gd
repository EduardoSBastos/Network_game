extends Node2D

@export var bullet_speed:float = 10

var owner_name:String = ""

func initialize(shooter_name:String):
	owner_name = shooter_name

func _process(delta):
	position += Vector2(bullet_speed * delta, 0)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server(): return
	var other_parent = area.get_parent()
	var other_name:String = other_parent.name
	if owner_name != other_name:
		print("Hit player: ", other_name)
		var health:Health = other_parent.get_node_or_null("Health")
		if health != null:
			health.receive_damage(10)
			self_destruct.rpc()

@rpc("any_peer", "call_local", "reliable")
func self_destruct():
	queue_free()
