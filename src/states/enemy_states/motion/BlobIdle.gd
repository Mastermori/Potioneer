extends EnemyMotion

class_name BlobIdle

export var min_wait_time := 1
export var max_wait_time := 5

onready var timer = Timer.new()

func _ready():
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "next_action")

func enter():
	timer.start(rand_range(min_wait_time, max_wait_time))
	
	owner.play_anim("idle")

func update(_delta):
	if not owner.targets.empty():
		emit_signal("transition", "chase")

func exit():
	timer.stop()

func next_action():
	emit_signal("transition", "move")
