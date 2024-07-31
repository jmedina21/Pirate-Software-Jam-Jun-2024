extends CharacterBody2D
signal enemy_died(position)

@onready var ray_cast_top_right = $"RayCast top-right"
@onready var ray_cast_bot_right = $"RayCast bot-right"
@onready var ray_cast_bot_left = $"RayCast bot-left"
@onready var ray_cast_top_left = $"RayCast top-left"
@onready var ray_cast_up_right = $"RayCast up-right"
@onready var ray_cast_up_left = $"RayCast up-left"
@onready var ray_cast_down_left = $"RayCast down-left"
@onready var ray_cast_down_right = $"RayCast down-right"

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var sprite_timer = $sprite_timer
@onready var attack_timer = $attack_timer

var skull_proyectile = preload("res://Scenes/skull_proyectile.tscn")
var is_attack_on_cooldown: bool = false
var flip_wait_time = 2
var attack_cooldown = 1
var player_in_sight = false

func _ready():
	sprite_timer.wait_time = flip_wait_time
	sprite_timer.start()
	if not is_in_group("Enemies"):
		add_to_group("Enemies")
		print("adding", self.name, 'to Enemies')
	
func _process(_delta):
	find_player()

func flip_around():
	if player_in_sight:
		return
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

func _on_timer_timeout():
	flip_around()
	

func find_player():
	if ray_cast_top_right.is_colliding() or ray_cast_bot_right.is_colliding():
		animated_sprite_2d.flip_h = false
		player_in_sight = true
		fire_projectile(Vector2(1,0))
	elif ray_cast_bot_left.is_colliding() or ray_cast_top_left.is_colliding():
		animated_sprite_2d.flip_h = true
		player_in_sight = true
		fire_projectile(Vector2(-1,0))
	elif ray_cast_up_left.is_colliding() or ray_cast_up_right.is_colliding():
		player_in_sight = true
		fire_projectile(Vector2(0,-1))
	elif ray_cast_down_left.is_colliding() or ray_cast_down_right.is_colliding():
		player_in_sight = true
		fire_projectile(Vector2(0,1))
	else:
		player_in_sight = false

func fire_projectile(direction):
	if is_attack_on_cooldown:
		return
	var skull_instance = skull_proyectile.instantiate()
	skull_instance.global_position = global_position
	is_attack_on_cooldown = true
	attack_timer.wait_time = attack_cooldown
	attack_timer.start()
	skull_instance.direction = direction

	add_child(skull_instance)

func _on_attack_timer_timeout():
	is_attack_on_cooldown = !is_attack_on_cooldown

func on_death():
	emit_signal("enemy_died", self.position)
	queue_free()
