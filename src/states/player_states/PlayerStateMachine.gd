extends StateMachine

func _ready():
	states_map = {
		"idle": $PlayerStanding,
		"walk": $PlayerWalking,
		"dash": $PlayerDash,
	}
