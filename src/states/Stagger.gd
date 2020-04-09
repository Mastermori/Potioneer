extends State

class_name Stagger

export var hit_sound := ""

func enter():
	owner.play_anim("hurt")
	owner.hitbox.set_deferred("monitorable", false)
	if not hit_sound == "":
		AudioLib.play_random_sound(hit_sound, self, true, .95 + randf() * .1)

func exit():
	owner.hitbox.set_deferred("monitorable", true)

func on_animation_finished(anim_name):
	if anim_name == "hurt":
		emit_signal("transition", "previous")
