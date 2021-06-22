extends Control

var buttons_kill_pid = []

func _ready():
	set_process(false)
	pass

func _process(delta):
	if Input.is_joy_button_pressed(0, JOY_L):
		if not buttons_kill_pid.has(JOY_L):
			buttons_kill_pid.append(JOY_L)
	if Input.is_joy_button_pressed(0, JOY_R):
		if not buttons_kill_pid.has(JOY_R):
			buttons_kill_pid.append(JOY_R)
	if Input.is_joy_button_pressed(0, JOY_L2):
		if not buttons_kill_pid.has(JOY_L2):
			buttons_kill_pid.append(JOY_L2)
	if Input.is_joy_button_pressed(0, JOY_R2):
		if not buttons_kill_pid.has(JOY_R2):
			buttons_kill_pid.append(JOY_R2)
	if Input.is_joy_button_pressed(0, JOY_L3):
		if not buttons_kill_pid.has(JOY_L3):
			buttons_kill_pid.append(JOY_L3)
	if Input.is_joy_button_pressed(0, JOY_R3):
		if not buttons_kill_pid.has(JOY_R3):
			buttons_kill_pid.append(JOY_R3)
	if Input.is_joy_button_pressed(0, JOY_SELECT):
		if not buttons_kill_pid.has(JOY_SELECT):
			buttons_kill_pid.append(JOY_SELECT)
	if Input.is_joy_button_pressed(0, JOY_START):
		if not buttons_kill_pid.has(JOY_START):
			buttons_kill_pid.append(JOY_START)
	if Input.is_action_just_released("ui_accept"):
		set_process(false)
		print(buttons_kill_pid)
		hide()
	get_tree().set_input_as_handled()


func _on_InputReceiver_draw():
	buttons_kill_pid.clear()
	print("Caca")
	pass # Replace with function body.


func _on_InputReceiver_hide():
			Globals.GameHub.set_input_kill_pid(buttons_kill_pid)
