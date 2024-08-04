extends CharacterBody2D

@export var current_position: Vector2

@onready var sprite_2d = $Sprite2D
@onready var animated_arow = $Sprite2D/AnimatedSprite2D
@onready var ui = $"../UI"
@onready var timer = $Timer
@onready var movement_sound = $movement_sound
@onready var attack_sound = $attack_sound
@onready var color_rect = $CanvasLayer/ColorRect
@onready var animation_player = $AnimationPlayer
@onready var canvas_layer = $CanvasLayer
@onready var point_light_2d = $PointLight2D

@export var attack_potion_count: int
@export var attack_cd_time: float = 0.6
@export var light_radius_width: int
@export var light_radius_height: int

var potion = preload("res://Scenes/damage_potion.tscn")
var attack_on_cooldown = false
var char_direction: String = 'right'
var arrow_direction: String = 'right'

var is_dead = false

func _ready():
	if light_radius_width or light_radius_height:
		print(point_light_2d.texture.width)
		point_light_2d.texture.width = light_radius_width
		point_light_2d.texture.height = light_radius_height
	else:
		point_light_2d.texture.width = 100
		point_light_2d.texture.height = 100
		print(point_light_2d.texture.width)
	canvas_layer.visible = true
	current_position = self.position
	ui.potion_amount.text = str(attack_potion_count)
	color_rect.visible = false

func _input(event):
	if is_dead:
		return
	var move_offset = Vector2.ZERO
	
	if event.is_action_pressed("left"):
		if arrow_direction != 'left':
			update_arrow_position('left')
			char_direction = 'left'
			return
		move_offset.x -= 16
		sprite_2d.flip_h = true
		movement_sound.play()	
	elif event.is_action_pressed("right"):
		if arrow_direction != 'right':
			update_arrow_position('right')
			char_direction = 'right'
			return
		move_offset.x += 16
		sprite_2d.flip_h = false
		movement_sound.play()
	elif event.is_action_pressed("up"):
		if arrow_direction != 'up':                
			update_arrow_position('up')
			char_direction = 'up'
			return
		move_offset.y -= 16
		movement_sound.play()
	elif event.is_action_pressed("down"):
		if arrow_direction != 'down':
			update_arrow_position('down')
			char_direction = 'down'
			return
		move_offset.y += 16
		movement_sound.play()
	var collision_info = move_and_collide(move_offset)
	
	if !collision_info:
		current_position += move_offset
		self.position = current_position
		

func _process(_delta):
	if Input.is_action_just_pressed('action'):
		fire_projectile()

func fire_projectile():
	if attack_potion_count == 0 or attack_on_cooldown:
		return
	var potion_instance = potion.instantiate()
	potion_instance.global_position = global_position
	attack_on_cooldown = true
	timer.wait_time = attack_cd_time
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
	attack_sound.play()
	attack_potion_count -= 1
	ui.potion_amount.text = str(attack_potion_count)

	
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
	attack_on_cooldown = false

func die():
	if not is_dead:
		animation_player.play("fade_out")
		is_dead = true
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
