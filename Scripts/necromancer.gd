extends Area2D
signal boss_died(position)
@onready var collision_shape_2d = $KillZone/CollisionShape2D
@onready var death_animation = $death_animation

func on_death():
	collision_shape_2d.disabled = true
	death_animation.play("death")
	
func _on_death_animation_animation_finished(anim_name):
	emit_signal("boss_died", global_position)
	queue_free()
