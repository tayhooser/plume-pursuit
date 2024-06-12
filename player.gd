extends Actor

@export var acceleration: float = .1
@export var ground_friction: float = .3
@export var air_friction: float = .15

#@onready var animation_tree : Animation 

var feathers := 1 # should be set in some global var later
var can_double_jump := (feathers > 2)
var can_triple_jump := (feathers > 3)
var direction
var prev_direction
var head_default_position

func _ready():
	$AnimationTree.active = true
	head_default_position = $HeadMarker.position

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		can_double_jump = (feathers > 2)
		can_triple_jump = (feathers > 3)

	# JUMP
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): # basic jump
			velocity.y = -abs(jump_velocity)
		else:
			if can_double_jump: # double jump
				velocity.y = -abs(jump_velocity)
				can_double_jump = false
			elif can_triple_jump:
				velocity.y = -abs(jump_velocity)
				can_triple_jump = false
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		velocity.y *= .25
	
	# DIRECTIONAL MOVEMENT
	prev_direction = direction
	direction = Input.get_axis("left", "right")
	if direction: # if pressing movement buttons
		velocity.x = lerp(velocity.x, direction * max_speed, acceleration)
		if direction != prev_direction and direction > 0:
			$Marker2D.scale.x = 1 # flip body
			$HeadMarker.scale.x = 1 # flip head
		elif direction != prev_direction and direction < 0:
			$Marker2D.scale.x = -1
			$HeadMarker.scale.x = -1
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, air_friction)
	
	# ANIMATION
	update_animation_parameters()
	move_and_slide()

func update_animation_parameters():
	if is_on_floor():
		$AnimationTree["parameters/conditions/not_falling"] = true
		if direction:
			#$AnimationTree["parameters/conditions/idle"] = false
			#$AnimationTree["parameters/conditions/is_running"] = true
			$AnimationPlayer.play("run")
			var current_frame = $AnimationPlayer.current_animation_position
			#print(round(current_frame * 10.0) / 10.0)
			print(direction)
			match round(current_frame * 10.0) / 10.0:
				0.0:
					# up 2 right 1
					$HeadMarker.position = head_default_position + Vector2(direction,-2)
				0.1:
					# up 1 right 1
					$HeadMarker.position = head_default_position + Vector2(direction,-1)
				0.2:
					$HeadMarker.position = head_default_position
				0.3:
					# up 1
					$HeadMarker.position = head_default_position + Vector2(0,-1)
				0.4:
					# up 3
					$HeadMarker.position = head_default_position + Vector2(0,-3)
		else:
			$AnimationPlayer.play("idle")
			$HeadMarker.position = head_default_position
			#$AnimationTree["parameters/conditions/idle"] = true
			#$AnimationTree["parameters/conditions/is_running"] = false
	else:
		$AnimationPlayer.play("falling")
		#$AnimationTree["parameters/conditions/not_falling"] = false
		#$AnimationTree.get("parameters/playback").travel("falling")
		
	if Input.is_action_just_pressed("bite"):
		print("bite")
		$HeadAnimationPlayer.stop()
		$HeadAnimationPlayer.play("bite")
