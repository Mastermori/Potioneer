extends ColorRect

signal finished()

func fade_in():
	$AnimationPlayer.play("fade_in")

func fade_out():
	print("Fading out")
	$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ["fade_in", "fade_out"]:
		emit_signal("finished")
