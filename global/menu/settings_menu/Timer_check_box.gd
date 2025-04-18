extends CheckBox

func _ready() -> void:
    toggled.connect(_on_timer_show_toggled)

func _on_timer_show_toggled(_bool : bool) -> void:
    print("Timer visible changed to ", _bool)
    ReferenceManager.on_menu_disabled_timer(_bool)