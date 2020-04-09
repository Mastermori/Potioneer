extends Character

class_name Enemy

signal got_target(target)
signal lost_target(target)

var targets := []

var dying := false

onready var enemy_anims := $EnemyAnimations

func play_anim(anim_name):
	if enemy_anims.has_animation(anim_name):
		enemy_anims.play(anim_name)
	else:
		.play_anim(anim_name)

func die():
	set_process(false)
	set_physics_process(false)
	.die()

func get_target() -> Character:
	if targets.empty():
		return null
	else:
		return targets[0]

func _on_AggroArea_body_entered(body):
	print(body.name)
	if body.is_in_group("player"):
		targets.append(body)
		emit_signal("got_target", body)

func _on_DeaggroArea_body_exited(body):
	if body.is_in_group("player"):
		targets.erase(body)
		emit_signal("lost_target", body)
