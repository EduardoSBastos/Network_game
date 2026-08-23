class_name PhotonLobby extends Node2D

@export var room_name_list: ItemList
@export var join_button: Button
@export var refresh_button: Button
@export var host_button: Button
@export var host_cancel_button: Button
@export var status_label:Label
@export var lobby_panel:Panel
@export var host_panel:Panel


func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)
	refresh_button.pressed.connect(update_rooms_list)
	host_button.pressed.connect(_on_host_button_pressed)
	host_cancel_button.pressed.connect(_on_host_cancel_button_pressed)
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	Fusion.connect_to_photon.call_deferred("user_%d" % randi())
	
	Fusion.connected_to_photon.connect(update_rooms_list)
	Fusion.room_joined.connect(_on_room_joined)
	Fusion.connection_failed.connect(_on_connection_failed)
	room_name_list.clear()
	
	lobby_panel.show()
	host_panel.hide()


func _on_host_button_pressed():
	lobby_panel.hide()
	host_panel.show()


func _on_host_cancel_button_pressed():
	host_panel.hide()
	lobby_panel.show()

	
func _on_create_room_button_pressed():	
	var options := FusionRoomOptions.new()
	options.max_players = 8
	options.is_visible = true
	Fusion.create_room(
		"test_%d" % Time.get_unix_time_from_system(),
		options
	)


func update_rooms_list():
	if not Fusion.is_connected_to_photon(): return
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
	Fusion.join_room(room_name)


func _on_room_joined():
	print("Successfully joined room!")
	print("Player ID: ", Fusion.get_local_player_id())
	status_label.text = "Successfully joined room! Player ID: %s" % Fusion.get_local_player_id()
	# TODO: Add Sccess Screen !!
	# Start your game / change scene / spawn player here


func _on_connection_failed(error: String):
	status_label.text = 'Connection Failed'
	print("Failed to join room: ", error)
	
