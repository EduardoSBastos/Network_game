class_name PhotonLobby extends Node2D

signal start_game

# Lobby Panel
@export var lobby_panel:Panel
@export var status_label:Label
@export var room_name_list: ItemList
@export var join_button: Button
@export var refresh_button: Button

# Host Panel
@export var host_panel:Panel
@export var room_name_textedit: TextEdit
@export var host_button: Button
@export var host_cancel_button: Button
@export var create_room_button: Button

# Room Panel
@export var room_panel:Panel
@export var players_itemlist:ItemList
@export var start_game_button:Button
@export var cancel_room_button:Button

var players:Dictionary

func _ready() -> void:
	join_button.pressed.connect(_on_join_button_pressed)
	refresh_button.pressed.connect(update_rooms_list)
	host_button.pressed.connect(_on_host_button_pressed)
	host_cancel_button.pressed.connect(_on_host_cancel_button_pressed)
	create_room_button.pressed.connect(_on_create_room_button_pressed)
	start_game_button.pressed.connect(_on_start_button_pressed)
	cancel_room_button.pressed.connect(_on_room_cancel_button_pressed)
	
	Fusion.register_broadcast_receiver(self)  # enables this node to receive broadcast RPCs
	Fusion.connect_to_photon.call_deferred("user_%d" % randi(), "sa")
	Fusion.connected_to_photon.connect(_on_connected_to_photon)
	Fusion.connected_to_photon.connect(update_rooms_list)
	Fusion.player_joined.connect(_on_player_joined)
	Fusion.player_left.connect(_on_player_left)
	Fusion.connection_failed.connect(_on_connection_failed)
	room_name_list.clear()
	
	lobby_panel.show()
	host_panel.hide()
	room_panel.hide()


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
	var room_name:String = room_name_textedit.text
	if room_name == "":
		room_name = "test_%d" % Time.get_unix_time_from_system()
	Fusion.create_room(
		room_name,
		options
	)
	host_panel.hide()
	room_panel.show()


func _on_connected_to_photon():
	print("==== Connected to Photon ====")
	status_label.text = 'Connection Successful'


func update_rooms_list():
	if not Fusion.is_connected_to_photon(): 
		return
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
	host_panel.hide()
	lobby_panel.hide()
	room_panel.show()
	start_game_button.disabled = true

# Host Functions:

func _on_start_button_pressed() -> void:
	if not Fusion.is_master_client(): return
	GameManager.instance.update_connected_players()
	Fusion.rpc(_change_scene)

@rpc("call_local", "reliable", "any_peer")
func _change_scene() -> void:
	host_panel.hide()
	lobby_panel.hide()
	room_panel.hide()
	start_game.emit()


func _on_room_cancel_button_pressed() -> void:
	Fusion.leave_room()
	host_panel.hide()
	room_panel.hide()
	lobby_panel.show()


func _on_player_joined(player_id: int, user_id: String):
	if not Fusion.is_master_client(): return
	players[player_id] = {
		"user_id": user_id
	}
	Fusion.rpc(update_player_list, players)


func _on_player_left(player_id: int, is_inactive: bool):
	if not Fusion.is_master_client(): return
	if not is_inactive:
		players.erase(player_id)
	Fusion.rpc(update_player_list, players)


@rpc("call_local", "reliable", "any_peer")
func update_player_list(current_players:Dictionary):
	players_itemlist.clear()
	for player_id in current_players:
		players_itemlist.add_item("player {0}".format([player_id]))


# func _on_room_joined():
# func _on_room_left():

func _on_connection_failed(error: String):
	status_label.text = 'Connection Failed'
	print("Failed to join room: ", error)
	
