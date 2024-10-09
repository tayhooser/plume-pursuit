extends Control

var viewport_size : Vector2

func _ready():
	viewport_size = get_viewport().get_visible_rect().size
	var offset = -5
	
	# set y to middle of screen
	$VBoxContainer.position.y = (viewport_size.y - offset) / 2
	$VBoxContainer/PlayButton.grab_focus()
	

func _process(_delta):
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Gameplay/gameplay.tscn")


func _on_quit_pressed():
	get_tree().quit()
