class_name CharacterBase extends KinematicBody2D

enum StateMachine {
	IDLE,
	IDLE_AIM
	WALK,
	WALK_AIM,
	JUMP,
	FALL,
	SHOOTER
}

const UP := Vector2(0, -1)
export (int) var JUMP_FORCE = -700
export (int) var JUMP_RELEASE_FORCE = -400
export (int) var MAXSPEED = 300
export (int) var ACCELERATION = 1000
export (int) var ACCELERATION_BLEND_ANIMATION = 10
export (int) var FRICTION = 5000
export (int) var GRAVITY = 2000
export (int) var ADDICIONAL_FALL_GRAVITY = 200

var state = StateMachine.IDLE
var motion := Vector2.ZERO
var enter_state := true

onready var nodePlayer : Node2D = get_node("NodePlayer")
onready var nodeArms : Node2D = get_node("NodePlayer/Skeleton2D/Column/Back/NodeArms")

onready var animationPlayer : AnimationPlayer = get_node("AnimationPlayer")
onready var animationTree : AnimationTree = get_node("AnimationTree")
onready var animationState = animationTree.get("parameters/playback")

onready var back : Bone2D = get_node("NodePlayer/Skeleton2D/Column/Back")
onready var neck : Bone2D = get_node("NodePlayer/Skeleton2D/Column/Back/Neck")

onready var endgun : Position2D = get_node("NodePlayer/Skeleton2D/Column/Back/NodeArms/ArmL/ForeArmL/HandL/HandPosition/Sprite/Shoot")
onready var attackCoolDown : Timer = get_node("AttackCoolDown")

var bullet = preload("res://bullet/Bullet.tscn")
var can_fire = true
var bullet_speed = 1500
var fire_rate = .6

onready var look : Node2D = get_node("Look")

func _ready() -> void:
	animationTree.active = true

func _physics_process(delta: float) -> void:
	look.look_at(get_global_mouse_position())
	_move_and_slide()

func _apply_gravity(delta: float) -> void:
	motion.y += GRAVITY * delta
	
func _move_and_slide() -> void:
	motion = move_and_slide(motion, UP)

func _get_input_axis() -> int:
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input.x
	
func _set_animation_tree_parameters(parameters: String, duration: float, delta: float):
	animationTree.set(parameters, lerp(animationTree.get(parameters), duration, ACCELERATION_BLEND_ANIMATION * delta))
	
func _travel_animation_state_parameters(state: String):
	animationState.travel(state)
	
func _apply_friction(delta: float) -> void:
	motion.x = move_toward(motion.x, 0, FRICTION * delta)
	
func _apply_acceleration(amount: int, delta: float) -> void:
	motion.x = move_toward(motion.x, MAXSPEED * amount, ACCELERATION * delta)
	
	if state == StateMachine.IDLE_AIM or state == StateMachine.WALK_AIM:
		MAXSPEED = 100
	else:
		MAXSPEED = 300
	
func _aim_mouse(pos: Vector2): 
	_set_flip_aim(pos.x < self.global_position.x)
	nodeArms.rotation += nodeArms.get_local_mouse_position().angle() * 0.30
	neck.rotation += neck.get_local_mouse_position().angle() - 92 * 0.15
	back.rotation += back.get_local_mouse_position().angle() * 0.10

func _shoot():
	if can_fire:
		animationTree.set("parameters/Aim/OneShot/active", true)
		
		var bullet_instance = bullet.instance()
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = endgun.global_position
		bullet_instance.rotation_degrees = look.rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(look.rotation))
		get_parent().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
func _set_flip_aim(value: bool):
	match value:
		true:
			nodePlayer.scale.x = -1
		false:
			nodePlayer.scale.x = 1

func _set_flip() -> void:
	if _get_input_axis() != 0:
		nodePlayer.scale.x = _get_input_axis()
	
func _animate_legs(parameters: String, delta: float):
	var is_forward: bool = (
		(nodePlayer.scale.x == 1 and motion.x > 0) or (nodePlayer.scale.x == -1 and motion.x < 0)
	)
	match is_forward:
		true: _set_animation_tree_parameters(parameters, 1, delta)
		false: _set_animation_tree_parameters(parameters, -1, delta)

func _enter_state(new_state) -> void:
	if state != new_state:
		state = new_state
		enter_state = true
