extends Control

export(NodePath) var GameSheetPopup
var modified_id := 0 setget set_modified_id
func set_modified_id(id):
	modified_id = id
	
func load_game_infos(game):
	get_node(GameSheetPopup).load_game_infos(game)

func handle_save(game):
	Globals.GameLibrary.edit_game_from_library(modified_id, game)
