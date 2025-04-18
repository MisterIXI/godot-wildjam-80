extends AudioStreamPlayer2D

func _on_player_body_hard_impact():
	pitch_scale = randf_range(0.8, 1.3)
	play()
