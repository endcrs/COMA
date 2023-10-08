extends Bone2D
tool

export(float, -360, 360) var max_rotation = 360
export(float, -360, 360) var min_rotation = -360

func _process(_delta):
	if rotation_degrees < max_rotation:
		rotation_degrees = max_rotation
	elif rotation_degrees > min_rotation:
		rotation_degrees = min_rotation
