extends StateMachine

class_name BlobStateMachine

func _ready():
	states_map = {
		"idle": $BlobIdle,
		"move": $BlobMove,
		"chase": $BlobChase,
		"stagger": $Stagger,
		"die": $Die
	}

func _change_state(state_name):
	if not _active:
		return
	
	if state_name in ["none"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)

