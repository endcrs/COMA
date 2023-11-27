extends Node

var score = 0
var score_enemy = 10
var time = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _reset():
	score = 0
	time = 0
