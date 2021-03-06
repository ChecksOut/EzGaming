extends Control

var grid_list = []
onready var SelectionHand = $IconTexture
var _offset := Vector2()

func _ready():
	yield(get_tree(),"idle_frame")
	_initialize_selection_grid()
	Globals.GameHub.VisualGameList.connect("item_selected", self, "_on_item_selected")
	Globals.GameLibrary.connect("library_updated", self, "_on_library_updated")

func _on_library_updated():
	_initialize_selection_grid()

func update_selection():
	pass

func _on_item_selected(idx):
	SelectionHand.set_global_position(grid_list[idx] - (SelectionHand.rect_size * 0.5))

func set_hand_on_item(idx):
	if grid_list.size() > idx:
		SelectionHand.set_global_position(grid_list[idx] - (SelectionHand.rect_size * 0.5))

func _initialize_selection_grid():
	if Globals.GameHub.VisualGameList.get_item_count() <= 0:
		return
	var column = Globals.GameHub.VisualGameList.max_columns
	var count = Globals.GameHub.VisualGameList.get_item_count()
	var icons_size = Globals.GameHub.VisualGameList.fixed_icon_size
	var cursor_pos := Vector2()
	var start_pos := Vector2()
	start_pos.x = Globals.GameHub.VisualGameList.margin_left
	start_pos.y = Globals.GameHub.VisualGameList.margin_top + (icons_size.y * 0.5)
	_offset = icons_size * 0.5
	print(_offset)
	cursor_pos = start_pos
	for i in count:
		if i % column == 0 and i != 0:
			cursor_pos.y += icons_size.y
			cursor_pos.x = start_pos.x + (icons_size.x * 0.5)
		elif i != 0:
			cursor_pos.x += icons_size.x
		else:
			cursor_pos.x += icons_size.x * 0.5
		grid_list.push_back(cursor_pos)
	print(grid_list)
	var i = Globals.GameHub.VisualGameList.get_selected_items()[0]
	SelectionHand.set_global_position(grid_list[i] - (SelectionHand.rect_size * 0.5))

func _input(event):
	pass
