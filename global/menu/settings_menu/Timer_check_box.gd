extends CheckBox

func _ready() -> void:
    toggled.connect(_on_timer_show_toggled)

func _on_timer_show_toggled(_bool : bool) -> void:
    print_rich("[color=Yellow]Timer >> [color=WHITE]Timer visible changed to %s" % _bool)
    ReferenceManager.on_hud_toggle(_bool)