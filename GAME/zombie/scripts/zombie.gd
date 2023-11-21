extends KinematicBody2D

var Life = 12
var speed = 65

var player_position = Vector2.ZERO
var target_position = Vector2.ZERO

var attacking = false
var crounched = false

export (int) var GRAVITY = 600

onready var deathParticle = get_node("NodeZombie/Body/Neck/ExplosionHead")
onready var player = get_parent().get_node("Player")
onready var Head = get_node("NodeZombie/Body/Neck/Head")
onready var ZombieAnimation = get_node("AnimationPlayer")

var blood = preload("res://zombie/particles/blood.tscn")

func _ready():
	# Vida do Inimigo
	Life = 12
	
	# Evita que o Inimigo inicie sem colisão
	$CollisionShapeZombie.disabled = false
	
func _physics_process(delta):
	if (Life > 0):
		if attacking:
			ZombieAnimation.play("atacando", .2)
		elif crounched:
			ZombieAnimation.play("caindo", .1)
			$CollisionShapeZombie.disabled = true
		else:
			_set_flip()
			_moviment(delta)
			ZombieAnimation.play("andando", .3)
	else:
		ZombieAnimation.play("morrendo")
		$CollisionShapeZombie.disabled = true
		
		
func _moviment(delta):
	player_position.x = player.global_position.x
	target_position.x = (player_position.x - position.x)
	
	if is_on_floor():
		target_position.y = 0
	else:
		target_position.y += GRAVITY * delta

	if position.distance_to(player_position) > 3:
		move_and_slide(target_position.normalized() * speed, Vector2.UP)

func _set_flip():
	if target_position.x < 0:
		transform.x.x = -1
	else:
		transform.x.x = 1

func _blood(pos, rot):
	var blood_instance = blood.instance()
	blood_instance.position = pos
	blood_instance.rotation = rot
	blood_instance.emitting = true
	get_tree().get_root().add_child(blood_instance)

# Bullet acertou a cabeça
func _on_Head_body_entered(body):
	if (body.is_in_group("bullet")):
		Life -= 4
		_blood(body.position, body.rotation)
		body.queue_free()
		
		if Life <= 0:
			Head.visible = false
			deathParticle.emitting = true

# Bullet acertou o corpo
func _on_Body_body_entered(body):
	if (body.is_in_group("bullet")):
		Life -= 2
		_blood(body.position, body.rotation)
		body.queue_free()

# Bullet acertou as pernas
func _on_Legs_body_entered(body):
	if (body.is_in_group("bullet")):
		Life -= 1
		_blood(body.position, body.rotation)
		body.queue_free()
		
		if !crounched:
			crounched = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "morrendo":
		queue_free()
	
	if anim_name == "caindo":
		crounched = false
		$CollisionShapeZombie.disabled = false

# Inicia o ataque do Zumbi
func _on_AreaAttack_body_entered(body):
	if (body.is_in_group("player")):
		attacking = true
	
# Finaliza o Ataque do Zumbi
func _on_AreaAttack_body_exited(body):
	if (body.is_in_group("player")):
		attacking = false

# Dano no Player
func _on_AreaDamage_body_entered(body):
	if (body.is_in_group("player")):
		body.Life -= 5


