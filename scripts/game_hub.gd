extends Node

export(PackedScene) var _EditToolScenes
var EditTool

export(PackedScene) var SettingsScene
export(PackedScene) var AddGameScene
export(PackedScene) var EditGameScene

onready var StateManager = $StateManager

export(NodePath) var GameIconListPath
var GameIconList

onready var SelectionHand = $Selection

const ICON_RATIO := 1 #1.778 is 16/9
const CFG_PATH := "user://settings.cfg"

var _current_mode := "Play"
var _loading_state
var lock_input : = false
var pid

func _ready():
	#_loading_state.resume()
	Globals.Configuration.reload_configuration()
	_setup_window()
	GameIconList = get_node(GameIconListPath)
	Globals.GameHub = self
	_initialize()
	Globals.GameLibrary.connect("library_updated", self, "_on_library_updated")
	Globals.Configuration.connect("configuration_updated", self, "_on_configuration_updated")
	_rebuild_game_icon_list()
	_initialize_edit_tool()
	switch_to_mode("Play")
	
func _setup_window():
	OS.current_screen = 0
	OS.window_position = Vector2()
	OS.window_fullscreen = Globals.Configuration.current["fullscreen"]
	
func _initialize():
	#yield()
	_set_language(Globals.Configuration.current["language"])
	_set_icon_size(Globals.Configuration.current["column_count"])
	_set_background_color(Globals.Configuration.current["background_color"])

	
func _on_configuration_updated():
	get_tree().reload_current_scene()
	
func _on_library_updated():
	_rebuild_game_icon_list()

func _initialize_edit_tool():
	if not EditTool is _EditToolScenes:
		EditTool = _EditToolScenes.instance()
		add_child(EditTool)
		EditTool.AddGame.connect("button_up", self, "_load_add_game_popup")
		EditTool.ModifyGame.connect("button_up", self, "_load_edit_game_popup")
		EditTool.DeleteGame.connect("button_up", self, "_delete_selected_game")
		EditTool.HideGame.connect("button_up", self, "_hide_selected_game")
		EditTool.AccessSetting.connect("button_up", self, "_load_setting_popup")

func _rebuild_game_icon_list():
	GameIconList.clear()
	var texture = Texture.new()
	if Globals.GameLibrary.get_game_library() == null:
		print("Invalid or missing Game Library")
		return
	for game in Globals.GameLibrary.get_game_library().games:
		if (_current_mode == "Play" and game.hide == false) or _current_mode == "Edit":
			var img = Image.new()
			var err = img.load(game.texture_path)
			if err != OK:
				print("game name: " + game.name)
				print("caca")
			var tex = ImageTexture.new()
			tex.create_from_image(img)
			texture = tex
			GameIconList.add_icon_item(tex, true)
	GameIconList.select(0, true)
	GameIconList.grab_focus()

func _load_add_game_popup():
	var add_game_instance = AddGameScene.instance()
	add_game_instance.owner = self
	add_child(add_game_instance)

	
func _load_edit_game_popup():
	if GameIconList.is_anything_selected():
		var id = GameIconList.get_selected_items()[0]
		var edit_game_instance = EditGameScene.instance()
		edit_game_instance.owner = self
		add_child(edit_game_instance)
		edit_game_instance.set_modified_id(id)
		edit_game_instance.load_game_infos(Globals.GameLibrary.get_game_from_id(id))
		
func _delete_selected_game():
	if GameIconList.is_anything_selected():
		var id = GameIconList.get_selected_items()[0]
		GameIconList.remove_item(id)
		Globals.GameLibrary.remove_game_from_library(Globals.GameLibrary.game_library.games[id])
		print("removed id : " + str(id))

func _hide_selected_game():
	if GameIconList.is_anything_selected():
		var id = GameIconList.get_selected_items()[0]
		Globals.GameLibrary.edit_hide_mode(id)
		
func _load_setting_popup():
	var settings_instance = SettingsScene.instance()
	settings_instance.set_owner(self)
	add_child(settings_instance)


func _set_background_color(rgb : Color):
	var new_color = StyleBoxFlat.new()
	new_color.bg_color = rgb
	$Panel.theme["Panel/styles/panel"] = new_color
	GameIconList.theme["ItemList/styles/bg"] = new_color

func _set_icon_size(nb):
	GameIconList.max_columns = nb
	var icon_max_width = int(OS.window_size.x / GameIconList.max_columns) - (20 - nb)  #10col = 6, 7col = 6, 5col = 20
	var icon_max_height = (icon_max_width / ICON_RATIO)
	GameIconList.fixed_icon_size = Vector2(icon_max_width, icon_max_height)
	GameIconList.fixed_column_width = icon_max_width
	print(icon_max_width)

func _gui_input(event):
	print("gui input")
	if event.is_action("ui_end"):
		print("kill pid 3 :" + str(pid))
		if pid:
			OS.kill(pid)
	if Input.is_action_pressed("ui_end"):
		print("kill pid 2 :" + str(pid))
		if pid:
			OS.kill(pid)

func _process(delta):
	
	GameIconList.ensure_current_is_visible()
	if Input.is_action_pressed("exit_app"):
		get_tree().quit()
	if lock_input:
		return
	if Input.is_action_just_released("play_mode"):
		switch_to_mode("Play")
		return
	if Input.is_action_just_released("edit_mode"):
		switch_to_mode("Edit")
		return
	match _current_mode:
		"Play":
			
			#GameIconList.grab_focus()
			#print("caca " + str(delta))
			if Input.is_action_pressed("ui_end"):
				#WORK IN BORDERLESS MODE
				print("process input1")
				if pid:
					print("kill 1 ")
					var arr = []
					#var arg = "/F /IM StateOfDecay2-Win64-Shipping.exe"
					var arg2 = "taskkill /F /PID " + "13772"
					arg2 = "tasklist /v /fo v"
					#print(arg)
					#OS.execute("C:/Windows/System32/taskkill.exe", [arg], false, arr)
					#var arg3 = ["/FI " + str("\"ImageName eq StateOfDecay2-Win64-Shipping.exe\"") + " /FI " + str("\"Status eq Running\"") + " /FO CSV"]
					var arg4 = "/v /fo csv"
					#OS.execute("C:/Windows/System32/tasklist.exe /v /fo csv", [arg4], false, arr)
					print(arr)
					var c = arr
					#print(arg3)
					arr = OS.shell_open("C:/Windows/System32/cmd.exe tasklist /v /fo csv")
					#OS.execute("C:/Windows/System32/cmd.exe", [arg2], false, arr)
					print(arr)
					#OS.kill(pid)
			if Input.is_joy_button_pressed(0, JOY_L) and Input.is_joy_button_pressed(0, JOY_R):
				#WORK IN FULLSCREEN MODE
				print("process input2")
				print("kill pid:" + str(pid))
				if pid:
					
					OS.kill(pid)
			pass
		"Edit":
			if Input.is_action_just_released("add_game"):
				_load_add_game_popup()
			if Input.is_action_just_released("edit_game"):
				_load_edit_game_popup()
			if Input.is_action_just_released("remove_game"):
				_delete_selected_game()
			if Input.is_action_just_released("activate_game"):
				_hide_selected_game()
			if Input.is_action_just_released("settings"):
				_load_setting_popup()
		"StandBy":
			#PREAPRE FOR GAME START
			pass
		_:
			print("Invalid mode in process !")

func switch_to_mode(mode_name):
	match mode_name:
		"Play":
			EditTool.hide()
			GameIconList.select(0, true)
			GameIconList.emit_signal("item_selected", 0)
			_current_mode = "Play"
			SelectionHand.show()
			GameIconList.grab_focus()
		"Edit":
			EditTool.show()
			SelectionHand.hide()
			_current_mode = "Edit"
		"StandBy":
			_current_mode = "StandBy"
		_:
			print("Invalid mode name !")

func _set_language(loc):
	TranslationServer.set_locale(loc)
	
func _handle_app_start(idx):
	switch_to_mode("Play")
	#print("caca id: " + str(index))
	var app_path = Globals.GameLibrary.game_library.games[idx].exe_path
	var arg_array = Globals.GameLibrary.game_library.games[idx].arguments.split(" ", false)
	print(arg_array)
	var output = []
	var time = OS.get_time()
	pid = OS.execute(app_path, arg_array, false, output)
	print(str(pid) + " output : " +  str(output))
	
func _on_ItemList_item_activated(index):
	_handle_app_start(index)

