extends Control

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("open")
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("open")

func _input(event):
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	print("button pressed")
	resume()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://ui/mainmenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
