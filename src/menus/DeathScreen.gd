extends Control

func _ready():
	$ScreenTransition.fade_in()

func _on_YesButton_pressed():
	get_tree().change_scene("res://src/levels/Arena.tscn")

func _on_NoButton_pressed():
	get_tree().quit()
