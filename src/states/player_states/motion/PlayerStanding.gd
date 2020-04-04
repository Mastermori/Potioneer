extends PlayerMotion

class_name PlayerStanding

func enter():
	owner.play_anim("idle")

func handle_input(event):
	if event.is_action_pressed("dash"):
		emit_signal("transition", "dash")

func update(_delta):
	var input_direction = get_input_direction()
	if input_direction:
		emit_signal("transition", "walk")
