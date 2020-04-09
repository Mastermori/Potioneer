extends PlayerState

class_name Punch

export var damage := 10
export var knockback := 300

func enter():
	var mouse_dir : Vector2 = owner.get_global_mouse_position() - owner.global_position
	owner.weapon.rotation = deg2rad(get_numeric_direction(mouse_dir) * -90 + 90)
	owner.play_anim("punch_" + str(get_numeric_direction(mouse_dir)))

func exit():
	pass

func on_animation_finished(anim_name : String):
	if anim_name.begins_with("punch_"):
		emit_signal("transition", "previous")

func _on_Hurtbox_area_entered(area : Area2D):
	if area.name == "Hitbox" and area.owner.is_in_group("enemy"):
		var enemy : Enemy = area.owner
		enemy.take_damage(damage)
		enemy.knockback((enemy.global_position - owner.weapon.global_position).normalized() * knockback)
