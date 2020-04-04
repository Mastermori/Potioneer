extends Node

class_name State

# warning-ignore:unused_signal
signal transition(next_state_name)

# Called when the state is first entered - use for initilization like starting
# animations
func enter():
	pass

# Called just before the next state is entered - used for clean up like
# resetting variables
func exit():
	pass

# Called whenever user input is detected while this is the active state
func handle_input(_event):
	pass

# Called every physicsprocess while this is the active state - used e.g. for timers
func update(_delta):
	pass

# Called whenever an animation finishes in the parent while this is the active state
func on_animation_finished(_anim_name):
	pass
