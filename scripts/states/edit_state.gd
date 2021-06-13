extends "res://scripts/state_t.gd"

func enter():
	#Show edit tool
	owner.EditTool.show()
	pass
	
func update(delta):
	pass
	
func input(event):
	pass
	
func exit():
	owner.EditTool.hide()
	pass
