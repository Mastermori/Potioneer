extends Node

class_name StateMachine

signal state_changed(current_state)

export(NodePath) var default_state
var states_map := {}

var states_stack := []
var current_state : State = null
var _active := false setget set_active

func ready():
	if not default_state:
		default_state = get_children()[0].get_path()
	for child in get_children():
		child.connect("transition", self, "_change_state")
	set_active(true)
	states_stack.push_front(get_node(default_state))
	current_state = states_stack[0]
	current_state.enter()

func _input(event):
	if not _active:
		return
	current_state.handle_input(event)

func _physics_process(delta):
	current_state.update(delta)


func _on_animation_finished(anim_name):
	if not _active:
		return
	current_state.on_animation_finished(anim_name)

func _change_state(state_name):
	if not _active:
		return
	current_state.exit()
	
	if state_name == "previous":
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[state_name]
	
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
	if state_name != "previous":
		current_state.enter()


func set_active(value):
	_active = value
	set_process(value)
	set_physics_process(value)
	if not value:
		states_stack = []
		current_state = null
