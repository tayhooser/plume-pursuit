extends Actor

@export var acceleration: float = .1
@export var ground_friction: float = .3
@export var air_friction: float = .15

var feathers := 1 # should be set in some global var later
var can_double_jump := (feathers > 2)
var can_triple_jump := (feathers > 3)
var direction
var prev_direction

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
			$Marker2D.scale.x = 1
		elif direction != prev_direction and direction < 0:
			$Marker2D.scale.x = -1
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, air_friction)
	
	# ANIMATION
	if is_on_floor():
		if direction:
			print("Walking animation...")
			#$AnimationPlayer.play("walk")
		else:
			print("Idle animation...")
			#$AnimationPlayer.play("idle")
	else:
		print("Falling animation...")
		#$AnimationPlayer.play("falling")

	move_and_slide()
