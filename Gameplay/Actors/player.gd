extends Actor

@export var acceleration: float = .1
@export var ground_friction: float = .3
@export var air_friction: float = .15
@export var jump_buffer_time: float = .1

var feathers := 0
var can_jump := true
var can_double_jump := false
var can_triple_jump := false
var double_jump_feather_req := 1
var triple_jump_feather_req := 2

var coyote_time := 0.1
var jump_buffer := false

var direction: int = 0
var prev_direction: int = 0
var head_default_position
var is_biting := false

func _ready():
	$AnimationTree.active = true
	head_default_position = $HeadMarker.position
	var currentLevel := get_parent()
	if "cameraBottomLimit" in currentLevel:
		$Camera2D.limit_bottom = currentLevel.cameraBottomLimit
	if "cameraRightLimit" in currentLevel:
		$Camera2D.limit_right = currentLevel.cameraRightLimit
	
	feathers = get_parent().get_parent().feathers
	can_double_jump = (feathers >= double_jump_feather_req)
	can_triple_jump = (feathers >= triple_jump_feather_req)

func _physics_process(delta):
	feathers = get_parent().get_parent().feathers
	# GRAVITY
	if not is_on_floor():
		velocity.y += gravity * delta
		if can_jump:
			if $Coyote_Timer.is_stopped():
				$Coyote_Timer.start(coyote_time)
	else:
		can_jump = true
		can_double_jump = (feathers >= double_jump_feather_req)
		can_triple_jump = (feathers >= triple_jump_feather_req)
		$Coyote_Timer.stop()
		if jump_buffer:
			velocity.y = -abs(jump_velocity)
			can_jump = false
			jump_buffer = false

	# JUMP
	if Input.is_action_just_pressed("jump"):
		if can_jump:
			velocity.y = -abs(jump_velocity)
			can_jump = false
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_time).timeout.connect(jump_buffer_timeout)
			if can_double_jump:
				velocity.y = -abs(jump_velocity)
				can_double_jump = false
			elif can_triple_jump:
				velocity.y = -abs(jump_velocity)
				can_triple_jump = false
				
	# below code is if you want holding jump to make you jump farther
	#if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		#velocity.y *= .25
	
	# DIRECTIONAL MOVEMENT
	if direction != 0:
		prev_direction = direction
	direction = int(Input.get_axis("left", "right"))
	if direction: # if pressing movement buttons
		velocity.x = lerp(velocity.x, direction * max_speed, acceleration)
		if direction == -(prev_direction) and direction != 0:
			scale.x *= -1
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, ground_friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, air_friction)
	update_animation_parameters()
	move_and_slide()

func coyote_timeout():
	can_jump = false

func jump_buffer_timeout():
	jump_buffer = false

func update_animation_parameters():
	if is_on_floor():
		if direction:
			if not is_biting:
				$HeadMarker.position = head_default_position + Vector2(-1, 0)
				$HeadAnimationPlayer.play("head_run")
				# sync up with body
				var current_frame = $AnimationPlayer.current_animation_position
				$HeadAnimationPlayer.seek(current_frame)
			else:
				# sync bite animation with body
				# BUG: not synced properly, outline sometimes gets fucked
				var current_frame = $AnimationPlayer.current_animation_position
				match int(floor(current_frame * 10.0)):
					0:
						# up 2 right 1
						$HeadMarker.position = head_default_position + Vector2(direction,-2)
					1:
						# up 1 right 1
						$HeadMarker.position = head_default_position + Vector2(direction,-1)
					2:
						$HeadMarker.position = head_default_position
					3:
						# up 1
						$HeadMarker.position = head_default_position + Vector2(0,-1)
					4:
						# up 3
						$HeadMarker.position = head_default_position + Vector2(0,-3)
			$AnimationPlayer.play("run")
		else: # not moving
			if not is_biting:
				$HeadMarker.position = head_default_position
				$HeadAnimationPlayer.play("idle")
				$AnimationPlayer.play("idle")
			else:
				$HeadMarker.position = head_default_position
				$HeadAnimationPlayer.play("bite")
				$AnimationPlayer.play("idle")
	else: # in air
		$HeadMarker.position = head_default_position
		$HeadAnimationPlayer.play("idle")
		$AnimationPlayer.play("falling")
		
	if Input.is_action_just_pressed("bite"):
		is_biting = true
		$HeadAnimationPlayer.stop()
		$HeadAnimationPlayer.play("bite")

func _on_head_animation_player_animation_finished(anim_name):
	match anim_name:
		"bite":
			is_biting = false
