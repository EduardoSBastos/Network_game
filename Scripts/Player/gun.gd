extends Node2D

var click_count:int

const BULLET_SCENE = preload("res://Scenes/Player/bullet.tscn")

signal on_score_change(new_value:int)

@export var autority_provider:Node

func _enter_tree():
	set_multiplayer_authority(autority_provider.get_multiplayer_authority())

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if multiplayer.is_server():
				_spawn_bullet.rpc()
			else:
				register_trigger.rpc_id(1)

@rpc("any_peer", "reliable")
func register_trigger():
	if not multiplayer.is_server(): return
	if multiplayer.get_remote_sender_id() != get_multiplayer_authority(): return
	_spawn_bullet.rpc()

@rpc("any_peer", "call_local", "reliable")
func _spawn_bullet():
	var bullet_instance:Node2D = BULLET_SCENE.instantiate()
	bullet_instance.global_position = position
	add_child(bullet_instance)
