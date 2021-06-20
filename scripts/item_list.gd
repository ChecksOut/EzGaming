extends ItemList


const ICON_RATIO := 1 #1.778 is 16/9

func _ready():
	pass

func set_items_size(nb):
	max_columns = nb
	var icon_max_width = int(OS.window_size.x / max_columns) - (20 - nb)  #10col = 6, 7col = 6, 5col = 20
	var icon_max_height = (icon_max_width / ICON_RATIO)
	fixed_icon_size = Vector2(icon_max_width, icon_max_height)
	fixed_column_width = icon_max_width
	#print(icon_max_width)
