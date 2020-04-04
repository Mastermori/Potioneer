extends State

# Initialize the state. E.g. change the animation.
func enter():
	pass


func on_animation_finished(_anim_name):
	emit_signal("finished", "dead")
