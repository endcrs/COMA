extends Node2D

var is_door = false
var is_open = false

onready var Anim = get_node("AnimationPlayer")
onready var OpenSong = get_node("OpenSong")
onready var ClosedSong = get_node("ClosedSong")

func _ready():
	pass
	
func _process(delta):
	if is_door and Input.is_action_just_pressed("ui_interact"):
		if !is_open:
			Anim.play("abrindo")
			is_open = true
			OpenSong.play()
		else:
			Anim.play_backwards("abrindo")
			is_open = false
			ClosedSong.play()

# Zumbi entrou na area da porta
func _on_EnemyArea2D_body_entered(body):
	if body.is_in_group("zombie") and !is_open:
		$OpenTimer.start(10)
		
# Player entrou na area da porta
func _on_PlayerArea2D_body_entered(body):
	if body.is_in_group("player"):
		is_door = true

# Player saiu da area da porta
func _on_PlayerArea2D_body_exited(body):
	if body.is_in_group("player"):
		is_door = false

func _on_OpenTimer_timeout():
	Anim.play("abrindo")
	is_open = true
	OpenSong.play()
