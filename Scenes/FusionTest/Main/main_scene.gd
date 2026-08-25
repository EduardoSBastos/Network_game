extends Node2D

const GAME_SCENE = preload("uid://bvjw3pmy0vmg4")

@export var photon_lobby:PhotonLobby


func _ready() -> void:
	photon_lobby.start_game.connect(start_network_game)


func start_network_game():
	var game_scene = GAME_SCENE.instantiate()
	add_child(game_scene)
