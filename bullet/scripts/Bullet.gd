extends KinematicBody2D

var velocity = Vector2(1, 0)
var speed = 5000

func _physics_process(delta):
	var collision_info = move_and_slide(velocity.normalized() * speed * delta)

func _on_QueueTimer_timeout():
	queue_free()
