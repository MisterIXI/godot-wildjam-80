extends Node
signal game_done()

var player_node : Node2D
var game_ui_node :  CanvasLayer
var highscore_node : Highscore_Manager
var game_manager : Game_Manager
var hud : Control

func on_game_done()->void:
    game_done.emit()
#get format 00h:00m:00s
func format(_value : float)->String:
    var _string :String
    var seconds: float = _value
    var minutes : int = int((_value / 60000)) %60
    var hours :int = int(_value /3600000)
    if hours > 0:
        _string = "%02dh:%02dm:%02ds" % [hours,minutes,seconds]
        return _string
    
    _string = "%02dm:%02ds" % [minutes,seconds]
    return _string