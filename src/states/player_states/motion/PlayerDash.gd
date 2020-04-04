extends PlayerMotion

class_name PlayerDash

export var dash_sound := 2
export var distance := 200
export var max_speed := 900

var direction := Vector2.ZERO
var distance_travelled := 0.0

var start_time

func enter():
	distance_travelled = 0
	
	speed = max_speed
	if get_input_direction():
		direction = get_input_direction().normalized()
	else:
		direction = owner.last_dir
	
	start_time = OS.get_ticks_msec()
	owner.play_anim("dash_start")
	Global.play_sound("dash", 2, owner, false, 1 + randf() * .1)

func update(delta):
	if distance_travelled > distance:
		emit_signal("transition", "idle")
	
	print("dashed " + str(distance_travelled) + " of " + str(distance))
	
	vel = direction * speed
	distance_travelled += vel.length() * delta
	owner.move_and_slide(vel, Vector2.ZERO)

func exit():
	print("Finished dash in " + str(OS.get_ticks_msec() - start_time))

func on_animation_finished(anim_name):
	print("Finished " + anim_name + " in " + name)
