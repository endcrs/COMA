extends KinematicBody2D

var velocity = Vector2.ZERO
var move_speed = 300
var gravity = 1200
var jump_force = -970
	
onready var braco_d = $Skeleton2D/coluna/costas/braco_d
onready var braco_e = $Skeleton2D/coluna/costas/braco_e
onready var mao_d = $Skeleton2D/coluna/costas/braco_d/antebaco_d/mao_d

func _physics_process(delta: float) -> void:
	braco_d.look_at(get_global_mouse_position())
	braco_e.look_at(get_global_mouse_position())

	velocity.y += gravity * delta
	
	_get_input()
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _get_input():
	var move_direction = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	
	velocity.x = move_speed * move_direction
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_force / 2
	

