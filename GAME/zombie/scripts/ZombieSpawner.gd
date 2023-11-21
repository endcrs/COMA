extends Position2D

var PrealoadedZombie = preload("res://zombie/zombie.tscn")


onready var ZombieTimer = $ZombieTimer

var NextZombieTimer = 5.0

func _ready():
	randomize()
	ZombieTimer.start(NextZombieTimer)


func _on_ZombieTimer_timeout():
	
	
	var Enemy = PrealoadedZombie.instance()
	Enemy.position = Vector2(position.x, position.y)
	add_child(Enemy)
	
	
	#ZombieTimer.start(NextZombieTimer)
