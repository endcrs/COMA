extends KinematicBody2D

var speedx = 0
var speedy = 980
var pushy = 0
var ground = Vector2(0, -1)


func _ready():
	pass
	
func _physics_process(delta):
	if is_on_floor():
		pushy +- delta
	if pushy > 1:
		pushy = 1
		
	var gravity = Vector2(0, pushy*speedy)
	move_and_slide(gravity, ground)


	position = Vector2(position.x + speedx, position.y)

func _on_detector_direita_body_entered(body):
	if body.is_in_group("player"):
		speedx = 2
	pass
	
	
func _on_detector_esquerda_body_entered(body):
	if body.is_in_group("player"):
		speedx = -2
	pass # Replace with function body.
	
func _on_detector_direita_body_exited(body):
	if body.is_in_group("player"):
		speedx = 0
	pass # Replace with function body.
func _on_detector_esquerda_body_exited(body):
	if body.is_in_group("player"):
		speedx = 0
	pass # Replace with function body.
