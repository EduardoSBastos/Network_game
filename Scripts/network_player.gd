extends CharacterBody2D

const SPEED: float = 500.0

var start_position:Vector2 = Vector2(0,0)

func initialize(id:int, start_position:Vector2):
	set_multiplayer_authority(id)
	position = start_position

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
