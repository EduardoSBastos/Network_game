extends ProgressBar

@export var health:Health
@export var player:Player

func _ready() -> void:
	health.health_changed.connect(request_update_value)
	player.death.connect(turn_visibility_off)

func request_update_value(current_health:int, max_health:int):
	if not multiplayer.is_server(): return
	_update_value.rpc(current_health, max_health)
	
@rpc("any_peer", "call_local", "reliable")
func _update_value(current_health:int, max_health:int):
	max_value = max_health
	value = current_health
	
func turn_visibility_off():
	visible = false
