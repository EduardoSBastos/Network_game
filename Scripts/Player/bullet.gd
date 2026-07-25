extends Node2D

@export var bullet_speed:float = 10

func _process(delta):
	position += Vector2(bullet_speed * delta, 0)
