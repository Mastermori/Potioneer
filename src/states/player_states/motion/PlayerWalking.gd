extends PlayerMotion

class_name PlayerWalking

export(float) var max_speed = 450

onready var step_sound_timer : Timer = Timer.new()

func enter():
	speed = max_speed
	vel = Vector2.ZERO

	var input_direction = get_input_direction()
	owner.play_anim("walk")
	step_sound_timer.wait_time = clamp(1 - speed / 750, .05, 1)
	step_sound_timer.one_shot = true
	add_child(step_sound_timer)

func handle_input(event : InputEvent):
	if event.is_action_pressed("dash"):
		emit_signal("transition", "dash")

func update(delta):
	var input_dir = get_input_direction()
	if not input_dir:
		emit_signal("transition", "idle")
		return
	
	if input_dir.x > 0:
		owner.sprite.flip_h = false
	elif input_dir.x < 0:
		owner.sprite.flip_h = true
	
	if step_sound_timer.is_stopped():
		Global.play_sound("walk", 0, owner, false, 1 - randf() * .1, randf() * 2)
		step_sound_timer.start()
	
	vel = input_dir.normalized() * speed
	owner.move_and_slide(vel, Vector2.ZERO)
	owner.last_dir = input_dir
