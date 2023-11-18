extends KinematicBody2D

export (int) var GRAVITY = 600

onready var player = get_parent().get_node("player")
var speed = 75
var player_position = Vector2.ZERO
var target_position = Vector2.ZERO


func _physics_process(delta):
	_set_flip()
	player_position.x = player.global_position.x
	target_position.x = (player_position.x - position.x)
	
	if is_on_floor():
		target_position.y = 0
	else:
		target_position.y += GRAVITY * delta

	if position.distance_to(player_position) > 3:
		move_and_slide(target_position.normalized() * speed, Vector2.UP)
	
	print(target_position.x)

func _set_flip():
	if target_position.x < 0:
		transform.x.x = -1
	else:
		transform.x.x = 1
