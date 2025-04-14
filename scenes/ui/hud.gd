extends Control
class_name HUDmenu
@onready var _timer_label : Label = $MarginContainer/PanelContainer/HBoxContainer/time_value
@onready var _collectable_label : Label = $MarginContainer/PanelContainer/HBoxContainer/collectable_value
var _time_starts : float = 0
var _collectables : int  = 0 :
    set(value) : 
        _collectable_label.text =str(value)

func _ready() -> void:
    _time_starts  = Time.get_ticks_msec()
    ReferenceManager.hud  =self
func _process(_delta: float) -> void:
    _update_timer()
func _update_timer()->void:
    _timer_label.text = _format(Time.get_ticks_msec()-_time_starts)
# get timer_score from hud
func get_timer_score() -> int:
    return int(Time.get_ticks_msec()-_time_starts)
    
# get collectable_score from hud
func get_collectable_score() -> int:
    return _collectables

#get format 00h:00m:00s:00ms
func _format(_value : float)->String:
    var mseconds : float = fmod(_value,100)
    var seconds: float = fmod(_value/1000, 60.0)
    var minutes : int = int((_value / 60000)) %60
    var hours :int = int(_value /3600000)
    var _string :String = "%02dh:%02dm:%02ds:%02dms" % [hours,minutes,seconds,mseconds]
    return _string
