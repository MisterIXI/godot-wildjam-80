extends Control
class_name HUDmenu
@onready var _timer_label : Label = $MarginContainer/PanelContainer/HBoxContainer/time_value
@onready var _collectable_label : Label = $MarginContainer/PanelContainer/HBoxContainer/collectable_value
var _game_done : bool = false
var collectables : int  = 0 :
    set(value) : 
        collectables = value
        _collectable_label.text =str(collectables)+"/5"

func _ready() -> void:
    ReferenceManager.hud  =self
    ReferenceManager.game_done.connect(_on_game_done)
    update_collectables()
# func _process(_delta: float) -> void:
#     if !_game_done:
#         _timer_label.text = ReferenceManager.format(Session.current_run_seconds)
    
# get collectable_score from hud
func _on_game_done() ->void:
    _game_done = true

func update_collectables():
    collectables = _format_collectables(Session.collectables)

func _format_collectables(_collectables : Dictionary) -> int:
  var count = 0
  for val in _collectables.values():
    if val:
      count += 1
  return count
