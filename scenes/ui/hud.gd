extends Control
class_name HUDmenu
@onready var _timer_label : Label = $MarginContainer/PanelContainer/HBoxContainer/time_value
@onready var _collectable_label : Label = $MarginContainer/PanelContainer/HBoxContainer/collectable_value
var _game_done : bool = false
var collectables : int  = 0 :
    set(value) : 
        collectables +=1
        _collectable_label.text ="x" +str(collectables)
        #TODO: add collectables to the session

func _ready() -> void:
    ReferenceManager.hud  =self
    ReferenceManager.game_done.connect(_on_game_done)
func _process(_delta: float) -> void:
    if !_game_done:
        _timer_label.text = ReferenceManager.format(Session.current_run_seconds)
    
# get collectable_score from hud
func get_collectable_score() -> int:
    return collectables
func _on_game_done() ->void:
    _game_done = true