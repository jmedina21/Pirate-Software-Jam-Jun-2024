extends Area2D
signal boss_died(position)

func on_death():
	emit_signal("boss_died", global_position)
	queue_free()
