extends Control

var viewport_size : Vector2
var tilemap_size : Vector2

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	tilemap_size.y = 17 * 16 # 17 tiles x 16px ea
	
	# set y to middle of screen
	$TileMap.position.y = (viewport_size.y - tilemap_size.y) / 2
	visible = false

func _process(_delta):
	pass

#open settings gui
func open():
	visible = true
	$TileMap/VBoxContainer/Resolution.grab_focus()
	
func close():
	visible = false
	get_parent().get_node("PauseMenu/TileMap/VBoxContainer/Settings").grab_focus()

func _on_x_pressed():
	close()

func _on_resolution_item_selected(index):
	match index:
		0:
			get_window().size = Vector2(1280, 720)
		1:
			get_window().size = Vector2(1920, 1080)
		2:
			get_window().size = Vector2(2560, 1440)
		3:
			get_window().size = Vector2(3840, 2160)
