extends StaticBody2D

var game_manager
@onready var game_manager_root = %GameManager

func set_game_manager(manager):
	game_manager = manager

func _on_area_2d_body_entered(_body):
	if game_manager:
		game_manager.pickup_loot('key')
	else:
		game_manager_root.pickup_loot(('key'))
	queue_free()
