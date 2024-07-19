extends CharacterBody2D

@export var currentPosition = Vector2(-8, 120)

@onready var sprite_2d = $Sprite2D

func _input(event):
	var move_offset = Vector2.ZERO

	if event.is_action_pressed("left"):
		move_offset.x -= 16
		sprite_2d.flip_h = true
	elif event.is_action_pressed("right"):
		move_offset.x += 16
		sprite_2d.flip_h = false
	elif event.is_action_pressed("up"):
		move_offset.y -= 16
	elif event.is_action_pressed("down"):
		move_offset.y += 16

	# Attempt to move the player, and handle collision detection
	var collision_info = move_and_collide(move_offset)
	if collision_info:
		print("Blocked by wall", collision_info.get_position())
	else:
		# Only update position if no collision occurred
		currentPosition += move_offset
		self.position = currentPosition
