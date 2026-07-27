class_name Player
extends CharacterBody2D

const SPEED: float = 500.0

@export var health:Health

signal death

func initialize(id:int, start_position:Vector2):
	set_multiplayer_authority(id)
	position = start_position

@rpc("any_peer", "call_local", "reliable")
func die():
	death.emit()
	set_process_mode(PROCESS_MODE_DISABLED)

func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
