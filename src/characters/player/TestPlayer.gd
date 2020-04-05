extends Character

class_name Player


onready var player_anims := $PlayerAnimations

func play_anim(anim_name):
	if player_anims.has_animation(anim_name):
		player_anims.play(anim_name)
	else:
		.play_anim(anim_name)

func _ready():
	for i in range(8):
		var anim = Animation.new()
		anim.length = .4
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, "Sprite:frame")
		anim.track_insert_key(0, 0, 1 + 7 * i)
		anim.track_insert_key(0, .2, 2 + 7 * i)
		player_anims.add_animation("walk_" + str(i), anim)
		print(i)
	$PlayerStateMachine.ready()
