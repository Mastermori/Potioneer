extends Enemy

export var damage := 10
export var knockback := 100

var vel := Vector2.ZERO

func _ready():
	state_machine = $BlobStateMachine
	ready()
	stop()

func stop():
	set_process(false)
	set_physics_process(false)
	state_machine.set_active(false)

func anim_finished(anim_name : String):
	$BlobStateMachine.on_animation_finished(anim_name)

func _physics_process(delta):
	move_and_slide(vel * rand_range(.9, 1.1))

func move_sound():
	AudioLib.play_sound("blob/move", 0, self, true, .9 + randf() * .2)


func _on_VisibilityEnabler2D_screen_entered():
	set_process(true)
	set_physics_process(true)
	state_machine.set_active(true)

func _on_VisibilityEnabler2D_screen_exited():
	stop()
