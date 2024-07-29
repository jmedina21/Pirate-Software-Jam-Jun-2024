extends Node

var key = preload("res://Scenes/key.tscn")
var enemy_death_positions = []
var enemy_count = 0

func _ready():
	print("GameManager ready")
	var enemies = get_tree().get_nodes_in_group("Enemies")
	enemy_count = enemies.size()
	print("Found ", enemies.size(), " enemies in the 'enemies' group")
	for enemy in enemies:
		connect_to_new_enemy(enemy)

func _on_enemy_died(position):
	enemy_death_positions.append(position)
	enemy_count -= 1
	print("Enemy died at position: ", position)
	print("Remaining enemies: ", enemy_count)
	
	if enemy_count == 0:
		print("Last enemy died at position:", enemy_death_positions[-1])
		spawn_key(enemy_death_positions[-1])

# Call this function when spawning new enemies during gameplay
func connect_to_new_enemy(enemy):
	if not enemy.is_connected("enemy_died", _on_enemy_died):
		enemy.connect("enemy_died", _on_enemy_died)
		print("Connected to enemy at position: ", enemy.position)
	else:
		print("Already connected to enemy at position: ", enemy.position)

func spawn_key(position):
	var static_object = key.instantiate()
	static_object.global_position = position
	get_parent().add_child(static_object)
	print("Static object spawned at position:", position)
