extends Control
class_name HUDmenu
@onready var _timer_label : Label = $MarginContainer/PanelContainer/HBoxContainer/time_value
@onready var _collectable_label : Label = $MarginContainer/PanelContainer/HBoxContainer/collectable_value
var _collectables : int  = 0 :
    set(value) : 
        _collectable_label.text ="x" +str(value)
        #TODO: add collectables to the session

func _ready() -> void:
    ReferenceManager.hud  =self
func _process(_delta: float) -> void:
    _timer_label.text = ReferenceManager.format(Session.current_run_seconds)
    
# get collectable_score from hud
func get_collectable_score() -> int:
    return _collectables
