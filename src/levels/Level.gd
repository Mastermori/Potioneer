extends Node2D

class_name Level

onready var canvas_layer = CanvasLayer.new()

func _ready():
	add_child(canvas_layer)
	Global.level = self
