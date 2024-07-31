extends Area2D
@onready var timer = $Timer
#@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $CanvasLayer/ColorRect

func _ready():
	color_rect.visible = false

func _on_body_entered(body):
	if body.name == "Player":
		#audio_stream_player_2d.play()
		animation_player.play("fade_out")
		body.is_dead = true
		print('player dies')

#func _on_audio_stream_player_2d_finished():
		#get_tree().reload_current_scene()


func _on_animation_player_animation_finished(anim_name):
	get_tree().reload_current_scene()
