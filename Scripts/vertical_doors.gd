extends StaticBody2D

@onready var game_manager = %GameManager
@onready var closed = $Area2D/Closed
@onready var opened = $Area2D/Opened
@onready var doors_collision = $doors_collision


func _on_area_2d_body_entered(body):
	if body.name == "Player" and  game_manager.inv_keys > 0:
		closed.visible = false
		opened.visible = true
		game_manager.inv_keys -= 1
		self.set_collision_layer_value(1, false)
