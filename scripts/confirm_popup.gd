extends Popup

var is_confirmed : bool

export(NodePath) var NoButtonPath
export(NodePath) var YesButtonPath


func _ready():
	yield(get_tree().create_timer(2.0), "timeout")
	if has_node(NoButtonPath) and has_node(YesButtonPath):
		get_node(NoButtonPath).disabled = false
		get_node(YesButtonPath).disabled = false

func _on_Yes_button_up():
	is_confirmed = true
	queue_free()

func _on_No_button_up():
	is_confirmed = false
	queue_free()
