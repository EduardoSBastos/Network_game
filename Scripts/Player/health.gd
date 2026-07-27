class_name Health
extends Node2D

@export var max_health:int = 100
@export var root_node:Node
var current_health: int

func _ready():
	current_health = max_health

@rpc("any_peer", "call_local", "reliable")
func receive_damage(damage:int) -> void:
	current_health -= damage
	print("current health:", str(current_health))
	if current_health <= 0:
		die()
		
func die() -> void:
	root_node.queue_free()
	
	
