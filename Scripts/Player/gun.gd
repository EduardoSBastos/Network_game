extends Node2D

const BULLET_SCENE = preload("res://Scenes/Player/bullet.tscn")

@export var autority_provider:Node

var click_count:int

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
	var shooter_name = get_parent().name
	bullet_instance.initialize(shooter_name)
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.global_position = global_position
