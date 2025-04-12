extends Node
class_name Game_Manager

enum GAMESTATE {
    MENU,
    GAME_RUNNING,
    GAME_OVER,
    GAME_WIN,
    PAUSE
}
var current_game_state : GAMESTATE
