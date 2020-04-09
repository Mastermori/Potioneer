extends State

class_name PlayerState

func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_direction

func get_numeric_direction(dir : Vector2):
	var input_angle = rad2deg(dir.angle_to(Vector2.RIGHT)) + 180
	return int(round(input_angle / 90) + 3) % 4
