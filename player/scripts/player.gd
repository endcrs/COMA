extends CharacterBase

func _process(delta: float) -> void:
	match state:
		StateMachine.IDLE: _state_idle(delta)
		StateMachine.IDLE_AIM: _state_idle_aim(delta)
		StateMachine.WALK: _state_walk(delta)
		StateMachine.WALK_AIM: _state_walk_aim(delta)
		StateMachine.JUMP: _state_jump(delta)
		StateMachine.FALL: _state_fall(delta)

func _state_idle(delta: float) -> void:
	_travel_animation_state_parameters("Move")
	_set_animation_tree_parameters("parameters/Move/IsOnFloor/blend_amount", true, delta)
	_set_animation_tree_parameters("parameters/Move/IsMoviment/blend_amount", 0, delta)
	
	_apply_gravity(delta)
	_apply_friction(delta)
		
	if _get_input_axis():
		_enter_state(StateMachine.WALK)
	elif Input.is_action_just_pressed("ui_right_mouse"):
		_enter_state(StateMachine.IDLE_AIM)
	elif Input.is_action_just_pressed("ui_jump"):
		_enter_state(StateMachine.JUMP)
		
		
func _state_idle_aim(delta):
	_travel_animation_state_parameters("Aim")
	_set_animation_tree_parameters("parameters/Move/IsOnFloor/blend_amount", true, delta)
	_set_animation_tree_parameters("parameters/Aim/IsMovementAim/blend_amount", 0, delta)
	
	_apply_gravity(delta)
	_apply_friction(delta)
	_aim_mouse(get_global_mouse_position())
	
	if _get_input_axis():
		_enter_state(StateMachine.WALK_AIM)
	elif Input.is_action_pressed("ui_left_mouse"):
		_shoot()
	elif Input.is_action_just_released("ui_right_mouse"):
		_enter_state(StateMachine.IDLE)
	elif Input.is_action_just_pressed("ui_jump"):
		_enter_state(StateMachine.JUMP)
	
func _state_walk(delta: float) -> void:
	_travel_animation_state_parameters("Move")
	_set_animation_tree_parameters("parameters/Move/IsOnFloor/blend_amount", true, delta)
	_set_animation_tree_parameters("parameters/Move/IsMoviment/blend_amount", 1, delta)
	
	_apply_gravity(delta)
	_apply_acceleration(_get_input_axis(), delta)
	_set_flip()
	
	if !_get_input_axis():
		_enter_state(StateMachine.IDLE)
	elif Input.is_action_just_pressed("ui_right_mouse"):
		_enter_state(StateMachine.WALK_AIM)
	elif Input.is_action_just_pressed("ui_jump"):
		_enter_state(StateMachine.JUMP)
	
func _state_walk_aim(delta):
	_travel_animation_state_parameters("Aim")
	_animate_legs("parameters/Aim/Walk/blend_position", delta)
	_set_animation_tree_parameters("parameters/Move/IsOnFloor/blend_amount", true, delta)
	_set_animation_tree_parameters("parameters/Aim/IsMovementAim/blend_amount", 1, delta)
	
	_apply_gravity(delta)
	_apply_acceleration(_get_input_axis(), delta)
	_aim_mouse(get_global_mouse_position())
	
	if !_get_input_axis():
		_enter_state(StateMachine.IDLE_AIM)
	elif Input.is_action_pressed("ui_left_mouse"):
		_shoot()
	elif Input.is_action_just_released("ui_right_mouse"):
		_enter_state(StateMachine.IDLE)
	elif Input.is_action_just_pressed("ui_jump"):
		_enter_state(StateMachine.JUMP)
	
func _state_jump(delta: float) -> void:
	_travel_animation_state_parameters("Move")
	_set_animation_tree_parameters("parameters/Move/IsOnFloor/blend_amount", false, delta)
	_set_animation_tree_parameters("parameters/Move/JumpOrFall/blend_amount", 0, delta)
	
	_apply_gravity(delta)
	_apply_acceleration(_get_input_axis(), delta)
	#_set_flip()
	
	if enter_state:
		enter_state = false
		motion.y = JUMP_FORCE
		
	if Input.is_action_just_released("ui_jump") and motion.y < JUMP_RELEASE_FORCE:
			motion.y = JUMP_RELEASE_FORCE
	if motion.y > 0:
		_enter_state(StateMachine.FALL)

func _state_fall(delta: float) -> void:
	_set_animation_tree_parameters("parameters/Move/JumpOrFall/blend_amount", 1, delta)
	
	_apply_gravity(delta)
	_apply_acceleration(_get_input_axis(), delta)
	#_set_flip()
	
	motion.y += ADDICIONAL_FALL_GRAVITY * delta
	
	if is_on_floor():
		_enter_state(StateMachine.IDLE)
