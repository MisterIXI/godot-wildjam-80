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
    _timer_label.text = _format(Session.current_run_seconds)
    
# get collectable_score from hud
func get_collectable_score() -> int:
    return _collectables

#get format 00h:00m:00s
func _format(_value : float) -> String:
    var seconds: int = int(_value) % 60
    var minutes: int = int(_value / 60) % 60
    var hours: int = int(_value / 3600)

    var _string: String
    if hours > 0:
        _string = "%02dh:%02dm:%02ds" % [hours, minutes, seconds]
    else:
        _string = "%02dm:%02ds" % [minutes, seconds]
        
    return _string
