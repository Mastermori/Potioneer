extends StateMachine

class_name PlayerStateMachine

func _ready():
	states_map = {
		"idle": $PlayerStanding,
		"walk": $PlayerWalking,
		"dash": $PlayerDash,
		"punch": $Punch,
		"stagger": $Stagger,
		"die": $Die
	}

func _change_state(state_name):
	if not _active:
		return
	
	if state_name in ["dash", "punch"]:
		states_stack.push_front(states_map[state_name])
	._change_state(state_name)
