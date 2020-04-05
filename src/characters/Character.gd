extends KinematicBody2D

class_name Character

var last_dir := Vector2.ZERO

onready var sprite := $Sprite
onready var character_anims := $CharacterAnimations

func _ready():
	for node in get_children():
		if node is AnimationPlayer:
			node.connect("animation_finished", self, "anim_finished")

func play_anim(anim_name):
	if character_anims.has_animation(anim_name):
		character_anims.play(anim_name)

func anim_finished(anim_name):
#	print("Finished animation: " + anim_name + " on " + name)
	pass

