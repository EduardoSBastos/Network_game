extends Node2D

@export var name_container: VBoxContainer
@export var start_button: Button

func _ready() -> void:
	Lobby.player_connected.connect(update_info)
	clear_players()
	update_info(1, {})
	if not multiplayer.is_server():
		start_button.disabled = true
	

func update_info(player_id, player_info)->void:
	var player_list = Lobby.players
	clear_players()
	for id in player_list.keys():
		add_players_to_lobby(player_list[id])

func add_players_to_lobby(player):
	var new_label: Label = Label.new()
	new_label.text = player["name"]
	name_container.add_child(new_label)
	
func clear_players():
	for child in name_container.get_children():
		child.queue_free()

func _on_start_button_pressed() -> void:
	Lobby.load_game.rpc("res://Scenes/high_level_example.tscn")
