extends Control


export(NodePath) var LanguageSelector
export(NodePath) var BackgroundColor
export(NodePath) var ColumnCount
export(NodePath) var Fullscreen
export(NodePath) var GameCount

signal language_changed
signal column_count_changed
# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize_current_settings()
	_load_game_count()
	Globals.GameHub.lock_input = true

func _initialize_current_settings():
	_initialize_language_selector()
	get_node(BackgroundColor).color = Globals.Configuration.current["background_color"]
	get_node(ColumnCount).text = str(Globals.Configuration.current["column_count"])
	get_node(Fullscreen).set_pressed(Globals.Configuration.current["fullscreen"])
	 
func _load_game_count():
	get_node(GameCount).text = str(Globals.GameLibrary.get_game_library().games.size() - 1)

func _initialize_language_selector():
	var local_array = TranslationServer.get_loaded_locales()
	var index = 0
	for loc in local_array:
		var lang = TranslationServer.get_locale_name(loc)
		get_node(LanguageSelector).add_item(lang)
		if loc == TranslationServer.get_locale():
			get_node(LanguageSelector).select(index)
		index += 1

func _on_BGColorPickerButton_color_changed(color):
	var new_color = StyleBoxFlat.new()
	new_color.bg_color = color
	Globals.GameHub.get_node("Panel").theme["Panel/styles/panel"] = new_color
	Globals.GameHub.VisualGameList.theme["ItemList/styles/bg"] = new_color

func _on_CloseButton_button_up():
	Globals.GameHub.lock_input = false
	queue_free()

func _on_ClearLibrary_pressed():
	Globals.GameLibrary.clear_library()
	_load_game_count()

func _on_LanguageSelector_item_selected(index):
	var local_array = TranslationServer.get_loaded_locales()
	var lang = local_array[index]
	if lang in local_array:
		Globals.Configuration.update_config_value("language", lang)

func _on_ColumnCount_text_entered(nb):
	if int(nb):
		nb = int(nb)
		nb = clamp(nb, 3, 10)
		print(nb)
		Globals.Configuration.update_config_value("column_count", nb)

func _on_BGColorPickerButton_popup_closed():
	Globals.Configuration.update_config_value("background_color", get_node(BackgroundColor).color)



func _on_Button_button_up():
	pass
	#var p = ProjectSettings.globalize_path("user://")
	#OS.shell_open("steam://rungameid/813780")


func _on_KillButton_button_up():
	$InputReceiver.show()
	$InputReceiver.set_process(true)
	$InputReceiver.grab_focus()


func _on_SavesLocationButton_button_up():
	var p = ProjectSettings.globalize_path("user://")
	OS.shell_open(p)


func _on_StartupLocationButton_button_up():
	pass # Replace with function body.
