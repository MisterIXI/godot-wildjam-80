extends AudioStreamPlayer2D
@export var flush_sfx_arr: Array[AudioStream]



func _on_player_body_hard_impact():
	stream = flush_sfx_arr.pick_random()
	play()
