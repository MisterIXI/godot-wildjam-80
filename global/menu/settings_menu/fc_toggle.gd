extends CheckBox

func _ready() -> void:
	toggled.connect(_on_fc_show_toggled)
	visibility_changed.connect(_on_fc_visibility_changed)

func _on_fc_show_toggled(_bool : bool) -> void:
	print_rich("[color=Yellow] Settings >> [color=WHITE]Fullscreen changed to %s" % _bool)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if _bool else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_fc_visibility_changed():
	# check for fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		button_pressed = true
	else:
		button_pressed = false
