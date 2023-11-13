extends KinematicBody2D

export (int) var GRAVITY = 600

onready var player = get_parent().get_node("player")
var speed = 100
var player_position = Vector2.ZERO
var target_position = Vector2.ZERO


func _physics_process(delta):
	player_position.x = player.global_position.x
	target_position.x = (player_position.x - position.x)
	
	if is_on_floor():
		target_position.y = 0
	else:
		target_position.y += GRAVITY * delta

	if position.distance_to(player_position) > 3:
		move_and_slide(target_position.normalized() * speed, Vector2.UP)
	print(player_position)