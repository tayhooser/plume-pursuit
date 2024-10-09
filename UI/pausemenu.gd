extends Control

var viewport_size : Vector2
var tilemap_size : Vector2
var settings_menu

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	tilemap_size.y = 9 * 16 # 9 tiles x 16px
	settings_menu = get_parent().get_node("Settings")
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	settings_menu.close()
	$AnimationPlayer.play_backwards("open")
	
	
func pause():
	get_tree().paused = true
	visible = true
	$AnimationPlayer.play("open")
	$TileMap/VBoxContainer/Resume.grab_focus()

func open_settings():
	settings_menu.open()
	pass

func _input(event):
	# opening/closing menu
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_settings_pressed():
	open_settings()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/mainmenu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_animation_player_animation_finished(anim_name):
	if not get_tree().paused:
		visible = false
		
