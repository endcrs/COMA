extends ColorRect

func _ready():
	visible = true
	$AnimationPlayer.play("fade_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
