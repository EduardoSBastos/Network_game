class_name PhotonLobby extends Node2D

@export var room_name_list: ItemList
@export var join_button: Button
@export var refresh_button: Button
@export var host_button: Button

func _ready() -> void:
	#Fusion.room_joined.connect(_on_room_joined)
	join_button.pressed.connect(_on_start_button_pressed)
	refresh_button.pressed.connect(update_rooms_list)
	host_button.pressed.connect(create_room)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	Fusion.connect_to_photon.call_deferred("user_%d" % randi())
	Fusion.connected_to_photon.connect(update_rooms_list)
	room_name_list.clear()


func create_room():
	var options := FusionRoomOptions.new()
	options.max_players = 8
	options.is_visible = true
	Fusion.join_or_create_room(
		"test_%d" % Time.get_unix_time_from_system(),
		options
	)


func update_rooms_list():
	room_name_list.clear()
	var rooms: Array[FusionRoomListing] = Fusion.get_room_list()
	for room in rooms:
		print("===============================================")
		print(room.name)
		print(room.player_count)
		room_name_list.add_item(room.name)

func _on_start_button_pressed() -> void:
	Lobby.load_game.rpc("res://Scenes/high_level_example.tscn")
