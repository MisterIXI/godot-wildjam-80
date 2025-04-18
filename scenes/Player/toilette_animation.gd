extends AnimatedSprite2D

func _on_start_throw():
	animation = "throw"

func _on_end_throw():
	animation = "default"
