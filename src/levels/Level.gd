extends Node2D

class_name Level

onready var canvas_layer := CanvasLayer.new()
onready var game_objects := $GameObjects
onready var spawn_pos := $GameObjects/PlayerSpawn

func _ready():
	add_child(canvas_layer)
	Global.level = self
	Global.player = preload("res://src/characters/player/Player.tscn").instance()
	game_objects.add_child(Global.player)
	Global.player.global_position = spawn_pos.global_position
	
	var health_bar = preload("res://src/hud/HealthBar.tscn").instance()
	canvas_layer.add_child(health_bar)
	Global.player.connect("took_damage", health_bar, "_entity_health_changed")
