extends CheckBox

func _ready() -> void:
	toggled.connect(_on_fc_show_toggled)

func _on_fc_show_toggled(_bool : bool) -> void:
	print("FC visible changed to ", _bool)
	
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if _bool else DisplayServer.WINDOW_MODE_WINDOWED)