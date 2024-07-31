extends Node

var key = preload("res://Scenes/key.tscn")
var enemy_death_positions = []
var enemy_count = 0
var inv_keys = 0
@onready var necromancer = $"../Necromancer"
@onready var hatch = $"../hatch"
@onready var ui = $"../UI"

func _ready():
	hatch.visible = false
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	enemy_count = enemies.size()
	
	
	for enemy in enemies:
		connect_to_new_enemy(enemy)
		
	necromancer.connect("boss_died", _on_boss_died)

func _on_enemy_died(position):
	enemy_death_positions.append(position)
	enemy_count -= 1
	if enemy_count == 0:
		spawn_item(key, enemy_death_positions[-1])

# Call this function when spawning new enemies during gameplay
func connect_to_new_enemy(enemy):
	if not enemy.is_connected("enemy_died", _on_enemy_died):
		enemy.connect("enemy_died", _on_enemy_died)

func spawn_item(item, position):
	var item_instance  = item.instantiate()
	item_instance.global_position = position
	if item_instance.has_method('set_game_manager'):
		item_instance.set_game_manager(self)
	get_parent().add_child(item_instance)

func pickup_loot(loot:String):
	if loot == 'key':
		inv_keys += 1
		ui.key_amount.text = str(inv_keys)
	
func _on_boss_died(position):
	hatch.visible = true
