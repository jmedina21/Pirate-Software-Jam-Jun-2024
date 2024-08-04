extends Area2D

@export var target_scene: String
@onready var animation_player = $AnimationPlayer
@onready var color_rect = $CanvasLayer/ColorRect

func _on_body_entered(body):
	if body.name == "Player":
		animation_player.play("fade_out")
		
func _on_animation_player_animation_finished(anim_name):
		get_tree().change_scene_to_file(target_scene)
