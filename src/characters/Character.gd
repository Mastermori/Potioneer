extends KinematicBody2D

class_name Character

signal took_damage(current_health, previous_health, max_health)
signal died()

# stats
export var max_health := 100
export var can_stagger := true

var last_dir := Vector2.ZERO

# stats
var health : float

var state_machine : StateMachine
var impulse := Vector2.ZERO

onready var hitbox := $Hitbox
onready var sprite := $Sprite
onready var character_anims := $CharacterAnimations

func _ready():
	if Engine.editor_hint:
		return
	for node in get_children():
		if node is AnimationPlayer:
			node.connect("animation_finished", self, "anim_finished")
	health = max_health

func ready():
	if not state_machine:
		print("no state machine set in " + name)
	else:
		state_machine.ready()
	play_anim("INIT")

func knockback(vel : Vector2):
	impulse += vel

func _physics_process(delta):
	if Engine.editor_hint:
		return
	move_and_slide(impulse)
	
	impulse *= .9
	if impulse.length() < 1:
		impulse = Vector2.ZERO

func take_damage(amount : int):
	health -= amount
	if health <= 0:
		hitbox.set_deferred("monitorable", false)
		die()
	else:
		if can_stagger and state_machine:
			print("stagger!")
			state_machine._change_state("stagger")
		emit_signal("took_damage", health, health + amount, max_health)

func die():
	state_machine._change_state("die")
	emit_signal("died")

func play_anim(anim_name):
	if character_anims.has_animation(anim_name):
		character_anims.play(anim_name)

func anim_finished(_anim_name):
	pass

