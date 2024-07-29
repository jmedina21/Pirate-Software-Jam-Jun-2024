extends Area2D
signal boss_died

func on_death():
	emit_signal("boss_died")
	queue_free()
