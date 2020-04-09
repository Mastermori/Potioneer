extends PlayerMotion

class_name PlayerDash

export var dash_sound := 2
export var distance := 75
export var max_speed := 600
export var cooldown := .45 setget set_cooldown

var direction := Vector2.ZERO
var distance_travelled := 0.0

var start_time

onready var cooldown_timer = Timer.new()

func _ready():
	cooldown_timer.one_shot = true
	set_cooldown(cooldown)
	add_child(cooldown_timer)

func enter():
	distance_travelled = 0
	start_time = OS.get_ticks_msec()
	
	speed = max_speed
	if get_input_direction():
		direction = get_input_direction().normalized()
	else:
		direction = owner.last_dir
	
	if not direction or not cooldown_timer.is_stopped():
		emit_signal("transition", "previous")
		return
	
	cooldown_timer.start()
	
	owner.play_anim("dash_start")
	AudioLib.play_sound("player/dash", 2, owner, false, 1 + randf() * .1, -10)

func update(delta):
	if distance_travelled > distance:
		emit_signal("transition", "idle")
	
#	print("dashed " + str(distance_travelled) + " of " + str(distance))
	
	vel = direction * speed
	distance_travelled += vel.length() * delta
	owner.move_and_slide(vel, Vector2.ZERO)

func exit():
#	print("Finished dash in " + str(OS.get_ticks_msec() - start_time))
	pass

func on_animation_finished(_anim_name):
	pass

func set_cooldown(cd):
	cooldown = cd
	cooldown_timer.wait_time = cooldown
