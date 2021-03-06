extends Node

export(PackedScene) var _EditToolScenes
var EditTool

export(PackedScene) var SettingsScene
export(PackedScene) var AddGameScene
export(PackedScene) var EditGameScene
export(NodePath) var _ItemListPath
var VisualGameList

onready var ShutdownConfirm = preload("res://visual/ConfirmPopup.tscn")
onready var SelectionHand = $Selection

#const ICON_RATIO := 1 #1.778 is 16/9
const CFG_PATH := "user://settings.cfg"

var _current_mode := "GameSelection"
var _loading_state
var _input_kill_pid := [] setget set_input_kill_pid
var lock_input : = false
var pid

func set_input_kill_pid(arr):
	_input_kill_pid = arr

func _ready():
	#_loading_state.resume()
	
	VisualGameList = get_node(_ItemListPath)
	Globals.GameHub = self
	Globals.Configuration.reload_configuration()
	_setup_window()
	_initialize_configuration()
	Globals.GameLibrary.connect("library_updated", self, "_on_library_updated")
	Globals.Configuration.connect("configuration_updated", self, "_on_configuration_updated")
	if Globals.GameLibrary.game_library.games.size() == 0:
		Globals.GameLibrary.clear_library()
	_rebuild_visual_game_list()
	_initialize_edit_tool()
	switch_to_mode("GameSelection")
	
	
func _setup_window():
	OS.current_screen = 0
	OS.window_position = Vector2()
	OS.window_fullscreen = Globals.Configuration.current["fullscreen"]
	
func _initialize_configuration():
	_set_language(Globals.Configuration.current["language"])
	_set_background_color(Globals.Configuration.current["background_color"])
	VisualGameList.set_items_size(Globals.Configuration.current["column_count"])
	
func _on_configuration_updated():
	get_tree().reload_current_scene()
	
func _on_library_updated():
	_rebuild_visual_game_list()

func _initialize_edit_tool():
	if not EditTool is _EditToolScenes:
		EditTool = _EditToolScenes.instance()
		add_child(EditTool)
		EditTool.AddGame.connect("button_up", self, "_load_add_game_popup")
		EditTool.ModifyGame.connect("button_up", self, "_load_edit_game_popup")
		EditTool.DeleteGame.connect("button_up", self, "_delete_selected_game")
		EditTool.HideGame.connect("button_up", self, "_hide_selected_game")
		EditTool.AccessSetting.connect("button_up", self, "_load_setting_popup")

func _rebuild_visual_game_list():
	VisualGameList.clear()
	#var texture = Texture.new()
	if Globals.GameLibrary.get_game_library() == null:
		print("Invalid or missing Game Library")
		return
	for game in Globals.GameLibrary.get_game_library().games:
		if (_current_mode == "GameSelection" and game.hide == false) or _current_mode == "EditLibrary":
			var img = Image.new()
			var img_texture: StreamTexture = load(game.texture_path)
			#var img_texture := StreamTexture.new()
			#var err = img_texture.load(game.texture_path)
			var err = img.load(game.texture_path)
			if err != OK:
				print("game name: " + game.name)
				print("caca")
			var tex = ImageTexture.new()
			tex.create_from_image(img)
			#texture = tex
			VisualGameList.add_icon_item(tex, true)
	VisualGameList.select(0, true)
	VisualGameList.grab_focus()

func _load_add_game_popup():
	var add_game_instance = AddGameScene.instance()
	add_game_instance.owner = self
	add_child(add_game_instance)

	
func _load_edit_game_popup():
	if VisualGameList.is_anything_selected():
		var id = VisualGameList.get_selected_items()[0]
		var edit_game_instance = EditGameScene.instance()
		edit_game_instance.owner = self
		add_child(edit_game_instance)
		edit_game_instance.set_modified_id(id)
		edit_game_instance.load_game_infos(Globals.GameLibrary.get_game_from_id(id))
		
func _delete_selected_game():
	if VisualGameList.is_anything_selected():
		var id = VisualGameList.get_selected_items()[0]
		VisualGameList.remove_item(id)
		Globals.GameLibrary.remove_game_from_library(Globals.GameLibrary.game_library.games[id])
		print("removed id : " + str(id))

func _hide_selected_game():
	if VisualGameList.is_anything_selected():
		var id = VisualGameList.get_selected_items()[0]
		Globals.GameLibrary.edit_hide_mode(id)
		
func _load_setting_popup():
	var settings_instance = SettingsScene.instance()
	settings_instance.set_owner(self)
	add_child(settings_instance)


func _set_background_color(rgb : Color):
	var new_color = StyleBoxFlat.new()
	new_color.bg_color = rgb
	$Panel.theme["Panel/styles/panel"] = new_color
	VisualGameList.theme["ItemList/styles/bg"] = new_color

#func _set_icon_size(nb):
#	VisualGameList.max_columns = nb
#	var icon_max_width = int(OS.window_size.x / VisualGameList.max_columns) - (20 - nb)  #10col = 6, 7col = 6, 5col = 20
#	var icon_max_height = (icon_max_width / ICON_RATIO)
#	VisualGameList.fixed_icon_size = Vector2(icon_max_width, icon_max_height)
#	VisualGameList.fixed_column_width = icon_max_width
#	print(icon_max_width)

func _gui_input(event):
	#print("gui input")
	if event.is_action("ui_end"):
		print("kill pid 3 :" + str(pid))
		if pid:
			OS.kill(pid)
	if Input.is_action_pressed("ui_end"):
		print("kill pid 2 :" + str(pid))
		if pid:
			OS.kill(pid)

func _process(delta):
	
	VisualGameList.ensure_current_is_visible()
	if Input.is_action_just_released("exit_app"):
		#self.queue_free()
		Globals.GameLibrary.free()
		Globals.Configuration.free()
		#yield(Globals.GameLibrary, "exit_ready")
		get_tree().quit()
	if lock_input:
		return
	if Input.is_action_just_released("play_mode"):
		switch_to_mode("GameSelection")
		return
	if Input.is_action_just_released("edit_mode"):
		switch_to_mode("EditLibrary")
		return
	match _current_mode:
		"GameSelection":
			
			#VisualGameList.grab_focus()
			#print("caca " + str(delta))
	
			pass
		"EditLibrary":
#			if Input.is_action_just_released("add_game"):
#				_load_add_game_popup()
#			if Input.is_action_just_released("edit_game"):
#				_load_edit_game_popup()
#			if Input.is_action_just_released("remove_game"):
#				_delete_selected_game()
#			if Input.is_action_just_released("activate_game"):
#				_hide_selected_game()
#			if Input.is_action_just_released("settings"):
#				_load_setting_popup()
			pass
		"BackgroundMode":
			#PREAPRE FOR GAME START
			
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
					OS.kill(pid)
			for inp in _input_kill_pid:
				if not Input.is_joy_button_pressed(0, inp):
					break
				if _input_kill_pid[_input_kill_pid.size() - 1] == inp:
					if pid:
						OS.kill(pid)
						call_deferred("switch_to_mode", "GameSelection")
#			if Input.is_joy_button_pressed(0, JOY_L) and Input.is_joy_button_pressed(0, JOY_R):
#				#WORK IN FULLSCREEN MODE
#				print("process input2")
#				print("kill pid:" + str(pid))
				#if pid:
#						OS.kill(pid)
#						switch_to_mode("GameSelection")
#
		_:
			print("Invalid mode in process !")

func switch_to_mode(mode_name):
	match mode_name:
		"GameSelection":
			OS.set_window_always_on_top(true)
			EditTool.hide()
			VisualGameList.select(0, true)
			SelectionHand.set_hand_on_item(0)
			#VisualGameList.emit_signal("item_selected", 0)
			SelectionHand.show()
			VisualGameList.grab_focus()
			_current_mode = "GameSelection"
		"EditLibrary":
			VisualGameList.select(0, true)
			SelectionHand.set_hand_on_item(0)
			EditTool.show()
			SelectionHand.hide()
			VisualGameList.grab_focus()
			_current_mode = "EditLibrary"
		"BackgroundMode":
			OS.set_window_always_on_top(false)
			VisualGameList.release_focus()
			_current_mode = "BackgroundMode"
			
		_:
			print("Invalid mode name !")

func _set_language(loc):
	TranslationServer.set_locale(loc)
	
func _handle_app_start(idx):
	if not _current_mode == "GameSelection":
		return
	# IF is button shutdown
	if idx == 0:
		var confirm_instance = ShutdownConfirm.instance()
		add_child(confirm_instance)
		confirm_instance.set_owner(self)
		confirm_instance.popup_centered()
		yield(confirm_instance, "popup_hide")
		if not confirm_instance.is_confirmed:
			VisualGameList.grab_focus()
			return
		OS.shell_open("powercfg -hibernate off")
			#OS.shell_open( %windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Standby  &&  ping -n 3 127.0.0.1  &&  powercfg -hibernate on)
	var app_path = Globals.GameLibrary.game_library.games[idx].exe_path
	var arg_array = Globals.GameLibrary.game_library.games[idx].arguments.split(" ", false)
	switch_to_mode("BackgroundMode")
	print(arg_array)
	var output = []
	var time = OS.get_time()
	pid = OS.execute(app_path, arg_array, false, output)
	print(str(pid) + " output : " +  str(output))
	if not pid:
		switch_to_mode("GameSelection")
	
func _on_ItemList_item_activated(index):
	_handle_app_start(index)

func _on_Input_Timer_timeout():
	lock_input = false
	pass # Replace with function body.
