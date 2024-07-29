extends Area2D
signal boss_died(position)

@export var current_position: Vector2

func _ready():
	current_position = self.position

func on_death():
	emit_signal("boss_died", current_position)
	queue_free()
