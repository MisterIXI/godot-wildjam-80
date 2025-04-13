extends CanvasLayer
class_name Game_UI
##################### REFERENCES 
@onready var _control_menu : Control =$Menu
@onready var _control_gamehud: Control = $HUD
@onready var _control_game_over: Control = $Game_Over
@onready var _control_game_win : Control = $Game_Win
@onready var _control_pause : Control = $Game_Pause
#################### BASE GLOBAL FUNCTIONS
func on_start_hud() ->void:
    _disable_all_menues()
    _control_gamehud.show()
func on_start_menu() -> void:
    _disable_all_menues()
    _control_menu.show()
func on_start_game_over()->void:
    _disable_all_menues()
    _control_game_over.show()
func on_start_game_win() ->void:
    _disable_all_menues()
    _control_game_win.show()
func on_start_game_paused()->void:
    _disable_all_menues()
    _control_pause.show()

###################### BASE PRIVATE FUNCTIONS
func _ready():
    ReferenceManager.game_ui_node = self
func _disable_all_menues()->void:
    _control_game_over.hide()
    _control_game_win.hide()
    _control_gamehud.hide()
    _control_menu.hide()
    _control_pause.hide()
