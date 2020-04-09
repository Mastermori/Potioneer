extends EnemyMotion

class_name BlobChase

export var max_speed := 90

var current_target : Character

onready var tween = Tween.new()

func _ready():
	add_child(tween)
	owner.connect("lost_target", self, "lost_target")

func enter():
	print("enterd chase")
	current_target = owner.get_target()
	owner.play_anim("move")
	tween.interpolate_property(self, "speed", 0, max_speed, 2, Tween.TRANS_CUBIC)
	tween.start()

func exit():
	speed = 0
	current_target = null
	tween.interpolate_property(owner, "vel", owner.vel, Vector2.ZERO, .3, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func update(_delta):
	if current_target:
		owner.vel = owner.position.direction_to(current_target.position) * speed


func on_animation_finished(anim_name):
	if anim_name == "move":
		owner.play_anim("move")

func lost_target(target):
	if current_target == target:
		emit_signal("transition", "idle")
