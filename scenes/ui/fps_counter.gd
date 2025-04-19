extends Label

func _ready():
	hide()

func _on_fps_update_timeout():
	text = str(int(Engine.get_frames_per_second())) + "FPS"
