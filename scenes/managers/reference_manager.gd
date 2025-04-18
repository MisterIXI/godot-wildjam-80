extends Node
signal game_done()
signal menu_toggled_hud(_bool : bool)
var player_node : Node2D
var game_ui_node :  CanvasLayer
var highscore_node : Highscore_Manager
var hud : HUDmenu

@export var fonts : Array[Font]
func on_hud_toggle( _bool : bool) ->void:
    menu_toggled_hud.emit(_bool)
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
