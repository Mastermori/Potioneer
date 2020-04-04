extends Character

class_name Player


onready var player_anims := $PlayerAnimations

func play_anim(anim_name):
	if player_anims.has_animation(anim_name):
		player_anims.play(anim_name)
	else:
		.play_anim(anim_name)

func _ready():
	$StateMachine.ready()
