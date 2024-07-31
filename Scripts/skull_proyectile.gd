extends Area2D

var speed = 75
var direction = Vector2()

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position += direction * speed * delta
	

func _on_body_entered(body):
	queue_free()
