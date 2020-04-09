extends KinematicBody2D

export var damage := 50.0
export var max_distance := 100.0

var vel : Vector2
var already_hit := []

onready var start_position = global_position
onready var anim_player := $AnimationPlayer

func _ready():
	anim_player.play("INIT")
	set_as_toplevel(true)

# to be overwritten in children to vary effect
func _apply_effect(enemy : Enemy):
	enemy.take_damage(damage)

func _explode():
	vel = Vector2.ZERO
	anim_player.play("explode")

func throw(init_vel : Vector2, extra_distance := 0.0):
	vel = init_vel
	max_distance += extra_distance

func _physics_process(delta):
	var distance = (global_position - start_position).length()
	
	if distance > max_distance:
		_explode()
	
	var collision := move_and_collide(vel * delta)
	if collision:
		_explode()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "explode":
		queue_free()
	if anim_name == "INIT":
		anim_player.play("move")

func _on_AreaOfEffect_area_entered(area):
	if area.name == "Hitbox" and area.owner.is_in_group("enemy"):
		if not area.owner in already_hit:
			_apply_effect(area.owner)
			already_hit.append(area.owner)
