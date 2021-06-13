extends PanelContainer

var _mouse_offset := Vector2()
var _dragging := false

onready var AddGame = $VBoxContainer/AddContainer/AddButton
onready var ModifyGame = $VBoxContainer/ModifyContainer/ModifyButton
onready var DeleteGame = $VBoxContainer/DeleteContainer/DeleteButton
onready var AccessSetting = $VBoxContainer/SettingsContainer/SettingsButton
onready var HideGame = $VBoxContainer/HideContainer/HideButton

func _on_EditTools_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_mouse_offset = get_global_mouse_position() - self.get_global_transform().origin
			_dragging = true
		else:
			_dragging = false
	elif event is InputEventMouseMotion:
		if _dragging:
			self.set_global_position(get_global_mouse_position() - _mouse_offset)

