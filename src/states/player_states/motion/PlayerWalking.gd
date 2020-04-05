extends PlayerMotion

class_name PlayerWalking

export(float) var max_speed = 150

var walk_anims

onready var step_sound_timer : Timer = Timer.new()

func _ready():
	step_sound_timer.one_shot = true
	add_child(step_sound_timer)

func enter():
	speed = max_speed
	vel = Vector2.ZERO
	
	step_sound_timer.wait_time = clamp(1 - speed / 350, .05, 1)

func handle_input(event : InputEvent):
	if event.is_action_pressed("dash"):
		emit_signal("transition", "dash")

func update(delta):
	var input_dir : Vector2 = get_input_direction()
	if not input_dir:
		emit_signal("transition", "idle")
		return
	
	var input_angle = rad2deg(input_dir.angle_to(Vector2.RIGHT)) + 180
	var walk_index = int(round(input_angle / 45) + 6) % 8
	owner.play_anim("walk_" + str(walk_index))
	
	if step_sound_timer.is_stopped():
		AudioLib.play_sound("player/walk", 0 if randf() > .5 else 2, owner, false, 1 + randf() * .1, randf() * 2)
		step_sound_timer.start(clamp(1 - speed / 300, .05, 1) + (.1 - randf() * .2))
	
	vel = input_dir.normalized() * speed
	owner.move_and_slide(vel, Vector2.ZERO)
	owner.last_dir = input_dir
