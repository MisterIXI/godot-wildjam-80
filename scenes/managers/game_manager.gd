extends Node
class_name Game_Manager

var _level_01_scene : PackedScene =  preload("res://scenes/_game/main.tscn")

enum GAMESTATE {
    MENU,
    GAME_RUNNING,
    GAME_OVER,
    GAME_WIN,
    PAUSE
}
var current_game_state : GAMESTATE

func change_gamestate(_new_game_state : GAMESTATE) ->void:
   match _new_game_state:
    GAMESTATE.MENU:
        # pausing
        get_tree().paused = true
        # game ui manager start Menu
    GAMESTATE.GAME_RUNNING:
        get_tree().paused = false
        # game ui manager start HUD
    GAMESTATE.GAME_OVER:
        get_tree().paused = true
        # game ui manager start GAME OVER 
    GAMESTATE.GAME_WIN:
        get_tree().paused = true
        # game ui manager start GAME WIN
    GAMESTATE.PAUSE:
        get_tree().paused = true
        # game ui manager start pause panel
    _:
        push_error("didnt get any new gamestate")

func change_level(_newlevel : int) -> void:
    match _newlevel:
        01:
           get_tree().change_scene_to_packed(_level_01_scene) 
        _:
            push_error("didnt get any cool new level to switch")