extends PlayerMotion

class_name OpenMixMenu

func enter():
	owner.play_anim("mix")

func handle_input(event):
	if event.is_action_pressed(""):
		# Close mix menu
		pass

func update(_delta):
	if get_input_direction():
		emit_signal("finished", "idle")

func on_animation_finished(anim_name):
	if anim_name == "mix":
		# Open mix menu
		pass

