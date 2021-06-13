extends Node

export(NodePath) var start_state
var current_state
var state_list := []

func _ready():
	_initialize_state_list()
	change_state(start_state)

func _initialize_state_list():
	for state in get_children():
		state_list.push_back(state.name)

func _process(delta):
	current_state.update(delta)

func _unhandled_input(event):
	current_state.input(event)

func change_state(new_state):
	current_state.exit()
	if new_state in state_list:
		current_state = new_state
	current_state.enter()
	
