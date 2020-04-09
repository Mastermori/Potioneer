extends EnemyMotion

class_name BlobMove

export var max_speed := 50

onready var tween := Tween.new()

var repeat : int
var current_dir : float

func _ready():
	add_child(tween)

func enter():
	speed = max_speed * rand_range(.6, 1)
	current_dir = randf() * 2.0 * PI
	repeat = randi() % 3 + 1
	move()

func move():
	current_dir = current_dir + randf() * .5
	var dir = Vector2.RIGHT.rotated(current_dir)
	
	tween.interpolate_property(owner, "vel", owner.vel, dir * speed, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	owner.play_anim("move")
	AudioLib.play_sound("blob/move", 0, self, true)

func update(_delta):
	if not owner.targets.empty():
		emit_signal("transition", "chase")

func exit():
	tween.interpolate_property(owner, "vel", owner.vel, Vector2.ZERO, .3, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func on_animation_finished(anim_name):
	if anim_name == "move":
		repeat -= 1
		if repeat > 0:
			move()
		else:
			emit_signal("transition", "idle")
