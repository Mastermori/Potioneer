extends Control

func _ready():
	$ScreenTransition.fade_in()

func _on_YesButton_pressed():
	print("Yes pressed")
	print(Global.player)
	get_tree().change_scene("res://src/levels/TheEther.tscn")

func _on_NoButton_pressed():
	get_tree().quit()
