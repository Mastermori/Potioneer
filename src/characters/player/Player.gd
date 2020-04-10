tool
extends Character

class_name Player

export var potion_speed := 200

onready var player_anims := $PlayerAnimations
onready var weapon := $MeeleContainer
onready var potion_spawn := $PotionSpawn

func play_anim(anim_name):
	if player_anims.has_animation(anim_name):
		player_anims.play(anim_name)
	else:
		.play_anim(anim_name)

func die():
	.die()
	AudioLib.play_sound("player/death", 0, self, false)
	$DeathTimer.start(.5)

func _input(event):
	if Engine.editor_hint:
		return
	if event.is_action_pressed("debug"):
		Music.set_mood_priority(Music.Mood.PEACEFUL)
		die()
	if event.is_action_pressed("throw") and not state_machine.current_state is Die:
		var potion = preload("res://src/potions/Potion.tscn").instance()
		var mouse_dir : Vector2 = (get_global_mouse_position() - global_position).normalized()
		add_child(potion)
		potion.global_position = potion_spawn.global_position
		potion.throw(potion_speed * mouse_dir)
		play_anim("throw_" + str($PlayerStateMachine/PlayerWalking.get_numeric_direction(mouse_dir)))

func _physics_process(_delta):
	pass

func anim_finished(anim_name : String):
	$PlayerStateMachine.on_animation_finished(anim_name)

func _ready():
	if Engine.editor_hint:
#		add_animations()
		return
	state_machine = $PlayerStateMachine
	ready()

func _on_DeathTimer_timeout():
	var transition := preload("res://src/menus/ScreenTransition.tscn").instance()
	Global.level.canvas_layer.add_child(transition)
	transition.connect("finished", self, "transition_finished")
	transition.fade_out()

func transition_finished():
	print("Game over!")
	get_tree().change_scene_to(preload("res://src/menus/DeathScreen.tscn"))

func add_animations():
	# add walking animations
	for i in range(4):
		if player_anims.has_animation("walk_" + str(i)):
			continue
		var anim = Animation.new()
		anim.length = .4
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, "Sprite:frame")
		anim.track_insert_key(0, 0, 1 + 6 * i)
		anim.track_insert_key(0, .2, 2 + 6 * i)
		player_anims.add_animation("walk_" + str(i), anim)
	# add idle animations
	for i in range(4):
		if player_anims.has_animation("idle_" + str(i)):
			continue
		var anim = Animation.new()
		anim.length = .1
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, "Sprite:frame")
		anim.track_insert_key(0, 0, 6 * i)
		player_anims.add_animation("idle_" + str(i), anim)
	# add throwing animations (used for punching right now - TODO)
	for i in range(4):
		if player_anims.has_animation("punch_" + str(i)):
			continue
		var anim = Animation.new()
		anim.length = .3
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, "Sprite:frame")
		anim.track_insert_key(0, 0, 3 + 6 * i)
		anim.track_insert_key(0, .1, 4 + 6 * i)
		anim.track_insert_key(0, .2, 5 + 6 * i)
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(1, "MeeleContainer/Hurtbox:monitoring")
		anim.track_insert_key(1, 0, true)
		anim.track_insert_key(1, anim.length, false)
		player_anims.add_animation("punch_" + str(i), anim)
	for i in range(4):
		if player_anims.has_animation("throw_" + str(i)):
			continue
		var anim = Animation.new()
		anim.length = .3
		anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(0, "Sprite:frame")
		anim.track_insert_key(0, 0, 3 + 6 * i)
		anim.track_insert_key(0, .1, 4 + 6 * i)
		anim.track_insert_key(0, .2, 5 + 6 * i)
		player_anims.add_animation("throw_" + str(i), anim)
