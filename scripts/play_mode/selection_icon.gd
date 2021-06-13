extends TextureRect

func _process(delta):
	_update_idle_cursor_movement(delta)

func _update_idle_cursor_movement(delta):
	var delta_move = Vector2(0.0,sin(OS.get_ticks_msec() * 0.01) * 10)
	#self.set_position(delta_move)
