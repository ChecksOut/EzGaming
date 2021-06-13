extends Node

var _GameLibraryScript = preload("res://scripts/library_manager.gd")
var GameLibrary

var _ConfigurationScript = preload("res://scripts/configuration.gd")
var Configuration

var GameHub

func _init():
	GameLibrary = _GameLibraryScript.new()
	Configuration = _ConfigurationScript.new()
	
func _ready():
	GameHub = get_tree().get_current_scene()

