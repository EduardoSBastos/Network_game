extends Sprite2D

@export var player:Player

func _ready() -> void:
	player.death.connect(on_death)
	
func on_death():
	visible = false
