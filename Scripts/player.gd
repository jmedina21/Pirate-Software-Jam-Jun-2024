extends CharacterBody2D

@export var currentPosition = Vector2(-8, 120)

@onready var sprite_2d = $Sprite2D
@onready var animated_arow = $Sprite2D/AnimatedSprite2D
@onready var marker_2d = $Marker2D

#var attack_ready = true
var potion = preload("res://Scenes/damage_potion.tscn")
var attack_potion_count = 5 


func _input(event):
	var move_offset = Vector2.ZERO
	
	if event.is_action_pressed("left"):
		move_offset.x -= 16
		sprite_2d.flip_h = true
		update_arrow_position('left')
	elif event.is_action_pressed("right"):
		move_offset.x += 16
		sprite_2d.flip_h = false
		update_arrow_position('right')
	elif event.is_action_pressed("up"):
		move_offset.y -= 16
		update_arrow_position('up')		
	elif event.is_action_pressed("down"):
		move_offset.y += 16
		update_arrow_position('down')		

	# Attempt to move the player, and handle collision detection
	var collision_info = move_and_collide(move_offset)
	
	if collision_info:
		print("Blocked by wall", collision_info.get_position())
	else:
		# Only update position if no collision occurred
		currentPosition += move_offset
		self.position = currentPosition
		

func _process(delta):
	if Input.is_action_just_pressed('action'):
		fire_projectile()

func fire_projectile():
	if attack_potion_count == 0:
		return
	var potion_instance = potion.instantiate()
	potion_instance.global_position = currentPosition
	
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
