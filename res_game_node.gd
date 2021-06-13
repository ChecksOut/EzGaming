extends Resource

export(String) var name
export(String) var exe_path
export(String) var texture_path
export(String) var arguments
export(bool) var hide

func _init(p_name = "New Game", p_exe_path = "", p_texture_path = "", p_arguments = "", p_hide = false):
	name = p_name
	exe_path = p_exe_path
	texture_path = p_texture_path
	arguments = p_arguments
	hide = p_hide
