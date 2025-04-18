extends AudioStreamPlayer2D

func _play_spring_sound():
	pitch_scale = randf_range(1.0, 1.5)
	play()

func _on_player_body_hopped_left():
	_play_spring_sound()


func _on_player_body_hopped_right():
	_play_spring_sound()
