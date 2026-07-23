extends Control

@export var name_edit:TextEdit

const CHARACTERS = 'abcdefghijklmnopqrstuvwxyz'

func generate_word(chars, length):
	var word: String
	var n_char = len(chars)
	for i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_host_pressed() -> void:
	var name = name_edit.text
	if name == "":
		name = generate_word(CHARACTERS, 5)
	Lobby.update_player_name(name)
	Lobby.create_game()
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")

func _on_join_pressed() -> void:
	var name = name_edit.text
	if name == "":
		name = generate_word(CHARACTERS, 5)
	Lobby.update_player_name(name)
	Lobby.join_game()
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
