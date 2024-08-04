extends Area2D
signal boss_died(position)
@onready var death_animation = $death_animation

func on_death():
	death_animation.play("death")

func _on_death_animation_animation_finished(anim_name):
	emit_signal("boss_died", global_position)
	queue_free()
