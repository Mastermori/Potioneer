extends Enemy

export var damage := 10
export var knockback := 100

var vel := Vector2.ZERO

func _ready():
	state_machine = $BlobStateMachine
	ready()

func anim_finished(anim_name : String):
	$BlobStateMachine.on_animation_finished(anim_name)

func _physics_process(delta):
	move_and_slide(vel * rand_range(.9, 1.1))

func move_sound():
	AudioLib.play_sound("blob/move", 0, self, true, .9 + randf() * .2)
