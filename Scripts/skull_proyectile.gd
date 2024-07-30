extends Area2D

var speed = 50
var direction = Vector2()

func _ready():
	set_as_top_level(true)
	
func _process(delta):
	position += direction * speed * delta
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		body.on_death()
	queue_free()
	


func _on_area_entered(area):
	if area.get_collision_layer_value(3) and area.has_method('on_death'):
		area.on_death()
