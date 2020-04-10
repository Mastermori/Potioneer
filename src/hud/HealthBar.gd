extends TextureProgress

class_name HealthBar


func _entity_health_changed(health, last_health, max_health):
	value = health / max_health * 100
