class_name GameManager extends Node2D

const GAME_SCENE = preload("uid://bvjw3pmy0vmg4")

static var instance

@export var photon_lobby:PhotonLobby

func _ready() -> void:
	instance = self
	photon_lobby.start_game.connect(start_network_game)


func start_network_game():
	var game_scene = GAME_SCENE.instantiate()
	add_child(game_scene)
	
func update_connected_players():
	print("players_updated")
	pass
