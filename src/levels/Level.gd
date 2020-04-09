extends Node2D

class_name Level

onready var canvas_layer := CanvasLayer.new()
onready var game_objects := $GameObjects

func _ready():
	add_child(canvas_layer)
	Global.level = self
	game_objects.add_child(Global.player)
