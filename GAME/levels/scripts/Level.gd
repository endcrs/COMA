extends Node2D

var PrealoadedZombie = preload("res://zombie/zombie.tscn")

onready var ZombieSpawnerLeft = $ZombieSpawnerLeft
onready var ZombieSpawnerRight = $ZombieSpawnerRight
onready var ZombieTimer = $ZombieTimer

var ZombieSpawner = Vector2.ZERO

export var NextZombieTimer = 5

func _ready():
	randomize()
	ZombieTimer.start(NextZombieTimer)

func _on_ZombieTimer_timeout():
	ZombieSpawner.x = rand_range(0, 1)
	NextZombieTimer = rand_range(NextZombieTimer, NextZombieTimer + 3)
	ZombieSpawner.y = ZombieSpawnerLeft.global_position.y
	var Enemy = PrealoadedZombie.instance()
	add_child(Enemy)
	
	if (ZombieSpawner.x >= 0.5):
		Enemy.position = Vector2(ZombieSpawnerLeft.global_position.x, ZombieSpawnerLeft.global_position.y)
	else:
		Enemy.position = Vector2(ZombieSpawnerRight.global_position.x, ZombieSpawnerRight.global_position.y)

