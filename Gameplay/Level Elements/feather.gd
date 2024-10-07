extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$AnimationPlayer.play("float")


func _on_body_entered(body):
	if body.name == "Player":
		get_parent().get_parent().feathers += 1
		queue_free()
