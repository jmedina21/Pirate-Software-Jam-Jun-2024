extends CharacterBody2D
signal enemy_died(position)

@export var current_position: Vector2
@export var patrol_distance = 16
@export var patrol_interval = 0.75

@onready var timer = $Timer
@onready var sprite_2d = $Sprite2D

var moving_down = true
var patrol_index = 0

func _ready():
	current_position = self.position
	timer.wait_time = patrol_interval
	timer.start()
	
	if not is_in_group("Enemies"):
		add_to_group("Enemies")
		print("adding", self.name, 'to Enemies')
		
func _on_timer_timeout():
	#if !moving_down: 
		#sprite_2d.flip_h = true
	#else:
		#sprite_2d.flip_h = false
	patrol()

func patrol():
	var move_offset = Vector2(0, patrol_distance) if moving_down else Vector2(0, -patrol_distance)
	
	var collision_info = move_and_collide(move_offset)
	
	if collision_info:
		moving_down = not moving_down
	else:
		current_position += move_offset
		self.position = current_position
		
func on_death():
	emit_signal("enemy_died", current_position)
	queue_free()
