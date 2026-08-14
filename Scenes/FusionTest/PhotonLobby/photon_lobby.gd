class_name PhotonLobby extends Node2D

@export var room_name_container: VBoxContainer
@export var host_button: Button
@export var join_button: Button

func _ready() -> void:
	#Fusion.room_joined.connect(_on_room_joined)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	Fusion.connect_to_photon.call_deferred("user_%d" % randi())
	Fusion.connected_to_photon.connect(update_rooms_list) # TODO: Remove this?
	clear_players()

func create_room():
	var options := FusionRoomOptions.new()
	options.max_players = 8
	options.is_visible = true
	Fusion.join_or_create_room(
		"test_%d" % Time.get_unix_time_from_system(),
		options
	)


func update_rooms_list():
	var rooms: Array[FusionRoomListing] = Fusion.get_room_list()
	for room in rooms:
		print("===============================================")
		print(room.name)
		print(room.player_count)
		add_room_to_lobby({"player": 1})


func add_room_to_lobby(room_info):
	var new_label: Label = Label.new()
	new_label.text = room_info["name"]
	room_name_container.add_child(new_label)


func clear_players():
	for child in room_name_container.get_children():
		child.queue_free()


func _on_start_button_pressed() -> void:
	Lobby.load_game.rpc("res://Scenes/high_level_example.tscn")
