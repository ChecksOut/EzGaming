extends Node

const _CFG_PATH = "user://settings.cfg"
var current := {}

signal configuration_updated

func _init():
	_load_config_from_disk()
	
func _create_new_config_file():
	var config = ConfigFile.new()
	config.set_value("General", "fullscreen", true)
	config.set_value("General", "resolution", OS.get_screen_size())
	config.set_value("General", "language", "fr")
	config.set_value("General", "column_count", 6)
	config.set_value("General", "background_color", Color.red)
	config.set_value("General", "kill_process_input", [4,5,10,11])
	config.save(_CFG_PATH)
	
func update_config_value(key, new_value):
	var config = ConfigFile.new()
	var err = config.load(_CFG_PATH)
	if err == OK:
		config.set_value("General", key, new_value)
		config.save(_CFG_PATH)
	emit_signal("configuration_updated")
	
func reload_configuration():
	_load_config_from_disk()
	
func _load_config_from_disk():
	var config = ConfigFile.new()
	var err = config.load(_CFG_PATH)
	if err == OK:
		if config.has_section_key("General", "fullscreen"):
			current["fullscreen"] = config.get_value("General", "fullscreen")
		else:
			config.set_value("General", "fullscreen", true)
		if config.has_section_key("General", "resolution"):
			current["resolution"] = config.get_value("General", "resolution")
		else:
			config.set_value("General", "resolution", OS.window_size)
		if config.has_section_key("General", "language"):
			current["language"] = config.get_value("General", "language")
		else:
			config.set_value("General", "language", "en")
		if config.has_section_key("General", "column_count"):
			current["column_count"] = config.get_value("General", "column_count")
		else:
			config.set_value("General", "column_count", 6)
		if config.has_section_key("General", "background_color"):
			current["background_color"] = config.get_value("General", "background_color")
		else:
			config.set_value("General", "background_color", Color.red)
		if config.has_section_key("General", "kill_process_input"):
			current["kill_process_input"] = config.get_value("General", "kill_process_input")
		else:
			#default is   L1 + R1 + Start + Select
			config.set_value("General", "kill_process_input", [4,5,10,11])
		config.save(_CFG_PATH)
	else:
		_create_new_config_file()
	emit_signal("configuration_updated")
			

