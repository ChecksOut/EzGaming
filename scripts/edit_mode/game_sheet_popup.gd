extends Panel

export(NodePath) var ExeFileDialog
export(NodePath) var TextureFileDialog
export(NodePath) var currentGameName
export(NodePath) var currentArguments
export(NodePath) var currentValueShow
export(NodePath) var CurrentGameIcon
export(NodePath) var CurrentExePath
var game_icon_path := ""
export(Resource) var GameResource

func _ready():
	Globals.GameHub.lock_input = true
	grab_focus()

func load_game_infos(game):
	get_node(currentGameName).text = game.name
	get_node(CurrentExePath).text = game.exe_path
	get_node(currentValueShow).set_pressed(game.hide)
	get_node(CurrentGameIcon).texture = load(game.texture_path)
	get_node(currentArguments).text = game.arguments

func _on_ExeFileDialog_file_selected(path):
	get_node(CurrentExePath).text = path

func _on_TextureFileDialog_file_selected(path):
	var selected_icon = load(path)
	var img = Image.new()
	var err = img.load(path)
	if err == OK:
		var texture = ImageTexture.new()
		texture.create_from_image(img)
		get_node(CurrentGameIcon).texture = texture
		game_icon_path = path
	else:
		print(selected_icon)
func _on_CancelSheet_button_up():
	_close_popup()

func _close_popup():
	Globals.GameHub.lock_input = false
	get_parent().queue_free()

func _on_SaveSheet_button_up():
	var game = GameResource.new()
	game.name = get_node(currentGameName).text
	game.exe_path = get_node(CurrentExePath).text
	game.arguments = get_node(currentArguments).text
	game.hide = get_node(currentValueShow).is_pressed()
	if game_icon_path != "":
		game.texture_path = game_icon_path
	#if get_node(CurrentGameIcon).texture != null:
		#game.texture_path = get_node(CurrentGameIcon).texture.get_path()
	#Globals.GameLibrary.add_game_to_library(game)
	get_parent().handle_save(game)
	_close_popup()

func _on_TextureAdd_button_up():
	get_node(TextureFileDialog).popup()
	
func _on_TextureClear_button_up():
	get_node(CurrentGameIcon).texture = null

func _on_ExeBrowse_button_up():
	get_node(ExeFileDialog).popup()
