extends CanvasLayer

func _ready():
	Global._reset()
	
func _process(delta):
	$Time.text = str(Global.time)
	$Score.text = "Score: " + str(Global.score)

func _on_Player_player_stats_changed(var player):
	$Life/Bar.rect_size.x = 266 * player.life / player.max_life

func _on_Timer_timeout():
	Global.time += 1
