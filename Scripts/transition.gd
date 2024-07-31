extends CanvasLayer

@onready var transition = $Transition
func play_fade_out():
	transition.play("fade_out")

func play_fade_in():
	transition.play("fade_in")	
