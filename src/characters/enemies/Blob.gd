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


func _on_Hurtbox_area_entered(area):
	if area.name == "Hitbox" and area.owner.is_in_group("play"):
		print("Hit player")
		var player = area.owner
		player.take_damage(damage)
		player.knockback((player.global_position - global_position).normalized() * knockback)
