extends CharacterBody2D

@export var current_position = Vector2(-8, 120)

@onready var sprite_2d = $Sprite2D
@onready var animated_arow = $Sprite2D/AnimatedSprite2D
@onready var marker_2d = $Marker2D
@onready var timer = $"../Timer"

#var attack_ready = true
var potion = preload("res://Scenes/damage_potion.tscn")
var attack_potion_count = 500 
var attack_on_cooldown = false
var char_direction: String = 'right'
var arrow_direction: String = 'right'


func _input(event):
	var move_offset = Vector2.ZERO
	
	if event.is_action_pressed("left"):
		if arrow_direction != 'left':
			update_arrow_position('left')
			char_direction = 'left'
			return
		move_offset.x -= 16
		sprite_2d.flip_h = true
	elif event.is_action_pressed("right"):
		if arrow_direction != 'right':
			update_arrow_position('right')
			char_direction = 'right'
			return
		move_offset.x += 16
		sprite_2d.flip_h = false
	elif event.is_action_pressed("up"):
		if arrow_direction != 'up':
			update_arrow_position('up')
			char_direction = 'up'
			return
		move_offset.y -= 16
	elif event.is_action_pressed("down"):
		if arrow_direction != 'down':
			update_arrow_position('down')
			char_direction = 'down'
			return
		move_offset.y += 16

	# Attempt to move the player, and handle collision detection
	var collision_info = move_and_collide(move_offset)
	
	if collision_info:
		print("Blocked by wall", collision_info.get_position())
	else:
		# Only update position if no collision occurred
		current_position += move_offset
		self.position = current_position
		

func _process(delta):
	if Input.is_action_just_pressed('action'):
		fire_projectile()

func fire_projectile():
	#if attack_potion_count == 0 or attack_on_cooldown:
		#return
	var potion_instance = potion.instantiate()
	potion_instance.global_position = current_position
	attack_on_cooldown = true
	timer.start()
	
	# Set the projectile's direction vector based on the arrow's rotation
	var direction: Vector2 = Vector2(1,0)
	
	 # Adjust direction based on arrow rotation
	if animated_arow.rotation_degrees == 0:
		direction = Vector2(0, 1)
	elif animated_arow.rotation_degrees == 90:
		direction = Vector2(-1, 0)
	elif animated_arow.rotation_degrees == 180:
		direction = Vector2(0, -1)
	elif animated_arow.rotation_degrees == -90:
		direction = Vector2(1, 0)
		
	potion_instance.direction = direction

	add_child(potion_instance)
	attack_potion_count -= 1

	
func update_arrow_position(direction):
	arrow_direction = direction
	animated_arow.position.y = 0				
	animated_arow.position.x = 0
	if direction == 'right':
		animated_arow.rotation_degrees = -90
		animated_arow.position.x = 8
	elif direction == 'left':
		animated_arow.rotation_degrees = 90
		animated_arow.position.x = -8
	elif direction == 'up':
		animated_arow.rotation_degrees = 180
		animated_arow.position.y = -10		
	elif direction == 'down':
		animated_arow.rotation_degrees = 0
		animated_arow.position.y = 10
		

func _on_timer_timeout():
	Engine.time_scale = 1
	attack_on_cooldown = false


