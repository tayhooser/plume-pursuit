extends Node2D

var playerNode

func _ready():
	playerNode = get_parent().get_parent().get_node("level 1").get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = "direction: " + str(playerNode.direction) + "\nprev direction: " + str(playerNode.prev_direction)
	pass
