extends RigidBody2D

var explosion = preload("res://bullet/Explosion.tscn")
var blood = preload("res://zombie/particles/blood.tscn")

func _on_Bullet_body_entered(body):
	if !body.is_in_group("player") and !body.is_in_group("zombie"):
		var explosion_instance = explosion.instance()
		explosion_instance.position = global_position
		get_tree().get_root().add_child(explosion_instance)
		queue_free()
		
	if body.is_in_group("zombie"):
		var blood_instance = blood.instance()
		blood_instance.position = global_position
		blood_instance.rotation = global_rotation
		blood_instance.emitting = true
		get_tree().get_root().add_child(blood_instance)
		queue_free()
