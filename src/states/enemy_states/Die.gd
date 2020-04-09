extends State

class_name Die

export var death_sound := ""

# Initialize the state. E.g. change the animation.
func enter():
	print("Died: " + owner.name)
	owner.play_anim("die")
	if not death_sound == "":
		AudioLib.play_random_sound(death_sound, self, true, .95 + randf() * .1)

func on_animation_finished(anim_name):
	if anim_name == "die":
		if not owner.is_in_group("player"):
			owner.state_machine.set_active(false)
			owner.queue_free()
#		emit_signal("finished", "dead")
