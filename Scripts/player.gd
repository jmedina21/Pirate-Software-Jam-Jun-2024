extends CharacterBody2D

@export var currentPostion = [-8,120]

@onready var sprite_2d = $Sprite2D

func _input(event):
	print(self.position)	
	if event.is_action_pressed("left"):
		currentPostion[0] -= 16
		sprite_2d.flip_h= true
	elif event.is_action_pressed("right"):
		currentPostion[0] += 16
		sprite_2d.flip_h= false
	elif event.is_action_pressed("up"):
		currentPostion[1] -= 16
	elif event.is_action_pressed("down"):
		currentPostion[1] += 16
		
	self.position = Vector2(currentPostion[0], currentPostion[1])	

	move_and_slide()
	
