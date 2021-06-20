extends Popup

var is_confirmed : bool

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	$Control/VBoxContainer/VSeparator/No.disabled = false
	$Control/VBoxContainer/VSeparator/Yes.disabled = false

func _on_Yes_button_up():
	is_confirmed = true
	queue_free()


func _on_No_button_up():
	is_confirmed = false
	queue_free()
