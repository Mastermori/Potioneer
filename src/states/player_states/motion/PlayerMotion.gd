extends Motion

class_name PlayerMotion

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_direction
