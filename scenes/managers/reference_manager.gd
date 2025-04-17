extends Node
signal game_done()

var player_node : Node2D
var game_ui_node :  CanvasLayer
var highscore_node : Highscore_Manager
var hud : Control

@export var fonts : Array[Font]

func on_game_done()->void:
    game_done.emit()
#get format 00h:00m:00s
func format(_value: float) -> String:
    var total_seconds: int = int(_value)
    var seconds: int = total_seconds % 60
    @warning_ignore("integer_division")
    var minutes: int = (total_seconds / 60) % 60
    @warning_ignore("integer_division")
    var hours: int = total_seconds / 3600

    if hours > 0:
        return "%02dh:%02dm:%02ds" % [hours, minutes, seconds]
    else:
        return "%02dm:%02ds" % [minutes, seconds]
