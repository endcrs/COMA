extends Control

func _ready():
	pass


func _on_ButtonPlayGame_pressed():
	$SelectLevels.visible = true
	$Menu.visible = false

func _on_ButtonExit_pressed():
	get_tree().quit()


func _on_ButtonLevel1_pressed():
	get_tree().change_scene("res://levels/level1/level1.tscn")


func _on_ButtonLevel2_pressed():
	get_tree().change_scene("res://levels/level2/florest.tscn")
