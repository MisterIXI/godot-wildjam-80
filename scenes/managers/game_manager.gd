extends Node
class_name Game_Manager

var _level_01_scene : PackedScene#=  preload("res://scenes/_game/main.tscn")
func _ready() -> void:
    ReferenceManager.game_manager  =self
enum GAMESTATE {
    MENU,
    GAME_RUNNING,
    GAME_OVER,
    GAME_WIN,
    PAUSE
}
var current_game_state : GAMESTATE
var current_scene : int  = 0
func change_gamestate(_new_game_state : GAMESTATE) ->void:
   match _new_game_state:
    GAMESTATE.MENU:
        # pausing
        get_tree().paused = true
        current_scene = 0
        ReferenceManager.game_ui_node.on_start_menu()
        # game ui manager start Menu
    GAMESTATE.GAME_RUNNING:
        get_tree().paused = false
        current_scene = 1
        ReferenceManager.game_ui_node.on_start_hud()
        # game ui manager start HUD
    GAMESTATE.GAME_OVER:
        get_tree().paused = true
        current_scene = 0
        ReferenceManager.game_ui_node.on_start_game_over()
        # game ui manager start GAME OVER 
    GAMESTATE.GAME_WIN:
        get_tree().paused = true
        ReferenceManager.game_ui_node.on_start_game_win()
        # game ui manager start GAME WIN
    GAMESTATE.PAUSE:
        get_tree().paused = true
        ReferenceManager.game_ui_node.on_start_game_paused()
        # game ui manager start pause panel
    _:
        push_error("didnt get any new gamestate")

func change_level(_newlevel : int) -> void:
    current_scene = _newlevel
    match _newlevel:
        01:
           get_tree().change_scene_to_packed(_level_01_scene) 
        _:
            push_error("didnt get any cool new level to switch")
