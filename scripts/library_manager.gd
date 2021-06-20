extends Node

const FILE_PATH = "user://game_list.tres"

const GameList = preload("res://res_game_library.gd")
#var game_list := GameList.new()
onready var game_library := GameList.new()

signal library_updated
#var _current_library : Dictionary = {}

func _init():
	game_library = GameList.new()
	load_library_from_disk()
	#_add_shutdown_icon()
	pass
	
func _add_shutdown_icon():
	var game_res = load("res://res_game_node.gd")
	var shutdown_icon = game_res.new()
	shutdown_icon.texture_path = "res://visual/icons/shutdown.png"
	shutdown_icon.name = "Shutdown"
	shutdown_icon.exe_path = "C:/Windows/System32/shutdown.exe"
	shutdown_icon.arguments = "/p /f"
	game_library.games.push_front(shutdown_icon)

func edit_hide_mode(id):
	if game_library.games.size() > id:
		game_library.games[id].hide = !game_library.games[id].hide
	_on_library_updated()
		
func clear_library():
	game_library.games.clear()
	_add_shutdown_icon()
	_on_library_updated()

func add_game_to_library(game : Resource):
	game_library.games.push_back(game)
	_on_library_updated()

func edit_game_from_library(id, game : Resource):
	if game_library.games.size() > id:
		game_library.games[id] = game
	_on_library_updated()

func remove_game_from_library_id(id : int):
	if game_library.games.size() > id:
		game_library.games.erase(id)
	else:
		print("Cannot find id:" + str(id) + " to remove from library")
	_on_library_updated()
		
func remove_game_from_library(game : Resource):
	var id = game_library.games.find(game)
	if id != -1:
		game_library.games.erase(game)
	else:
		print("Cannot find id:" + str(game) + " to remove from library")
	_on_library_updated()

func _on_library_updated():
	save_library_to_disk()
	emit_signal("library_updated")
	
func get_game_library():
	return game_library
	
func get_game_from_id(id):
	return game_library.games[id]
	
func save_library_to_disk():
	var path = "user://game_list.tres"
	ResourceSaver.save(FILE_PATH, game_library)

func load_library_from_disk():
	var file = File.new()
	if not file.file_exists(FILE_PATH):
		print("File does not exist !")
		return
	game_library = load(FILE_PATH)
