extends CanvasLayer

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
