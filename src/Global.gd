extends Node

var level : Level
var player : Player

func _ready():
	player = preload("res://src/characters/player/Player.tscn").instance()
