extends Node2D

var click_count:int

signal on_score_change(new_value:int)

@export var autority_provider:Node

func _enter_tree():
	set_multiplayer_authority(autority_provider.get_multiplayer_authority())

func _input(event: InputEvent) -> void:
	
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if multiplayer.is_server():
				_increment_click()
			else:
				# register_click.rpc_id(1)
				_increment_click()

@rpc("any_peer", "reliable")
func register_click():
	#if not multiplayer.is_server(): return
	if multiplayer.get_remote_sender_id() != get_multiplayer_authority(): return
	_increment_click()

func _increment_click():
	click_count += 1
	update_click_count.rpc(click_count)

@rpc("any_peer", "call_local", "reliable")
func update_click_count(value: int):
	click_count = value
	on_score_change.emit(value)
