class_name PhotonLobby extends Node2D

@export var room_name_list: ItemList
@export var join_button: Button
@export var refresh_button: Button
@export var host_button: Button

func _ready() -> void:
	#Fusion.room_joined.connect(_on_room_joined)
	join_button.pressed.connect(_on_join_button_pressed)
	refresh_button.pressed.connect(update_rooms_list)
	host_button.pressed.connect(_on_host_button_pressed)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	Fusion.connect_to_photon.call_deferred("user_%d" % randi())
	Fusion.connected_to_photon.connect(update_rooms_list)
	room_name_list.clear()


func _on_host_button_pressed():
	var options := FusionRoomOptions.new()
	options.max_players = 8
	options.is_visible = true
	Fusion.create_room(
		"test_%d" % Time.get_unix_time_from_system(),
		options
	)


func update_rooms_list():
	room_name_list.clear()
	var rooms: Array[FusionRoomListing] = Fusion.get_room_list()
	for room in rooms:
		room_name_list.add_item(room.name)

func _on_join_button_pressed() -> void:
	var selected_items = room_name_list.get_selected_items()
	if selected_items.size() == 0:
		print("select a room!")
		return
	if selected_items.size() > 1:
		print("Select only one room!")
		return
	var room_name = room_name_list.get_item_text(selected_items[0])
	# TODO: Test if connection worked
	# TODO: Change to game scene
	Fusion.join_room(room_name)
	
	#Lobby.load_game.rpc("res://Scenes/high_level_example.tscn")
