extends Area2D
@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _on_body_entered(body):
	if body.name == "Player":
		audio_stream_player_2d.play()
		body.is_dead = true
		print('player dies')

func _on_audio_stream_player_2d_finished():
		get_tree().reload_current_scene()
