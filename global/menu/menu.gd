extends Node

@export var disable_menu : bool = false

@export var main_menu : MainMenu
@export var pause_menu : PauseMenu
@export var settings_menu : SettingsMenu
@export var leaderboard_menu : LeaderboardMenu
@export var hud_menu : HUDmenu
@export var win_menu : WinMenu

func _ready():
  pause_menu.hide()
  settings_menu.hide()
  if disable_menu and not OS.get_name() == "Web":
    main_menu.hide()
  else:
    main_menu.show()
    _on_mm_visibility_changed()
  
  main_menu.visibility_changed.connect(_on_mm_visibility_changed)
  main_menu.play_button.pressed.connect(_on_mm_play)
  main_menu.leaderboard_button.pressed.connect(_on_mm_leaderboard)
  main_menu.settings_button.pressed.connect(_on_mm_settings)

  pause_menu.visibility_changed.connect(_on_pm_visibility_changed)
  pause_menu.resume_button.pressed.connect(_on_pm_resume)
  pause_menu.settings_button.pressed.connect(_on_pm_settings)
  pause_menu.reset_button.pressed.connect(_on_pm_reset)
  pause_menu.menu_button.pressed.connect(_on_pm_menu)

  settings_menu.confirm_button.pressed.connect(_on_sm_confirm)

  leaderboard_menu.back_button.pressed.connect(_on_lm_back)

  win_menu.confirm_button.pressed.connect(_on_wm_confirm)


## Main menu
func _on_mm_visibility_changed() -> void:
  if main_menu.visible:
    if not get_tree().paused:
      get_tree().paused = true
      print_rich("[color=MAGENTA]Menu >> [color=WHITE]Game tree has been paused.")

func _on_mm_play() -> void:
  if get_tree().paused:
    get_tree().paused = false
    print_rich("[color=MAGENTA]Menu >> [color=WHITE]Game tree has been resumed.")


func _on_mm_settings() -> void:
  settings_menu.show()
  settings_menu.last_menu = main_menu


func _on_mm_leaderboard() -> void:
  leaderboard_menu.show()


## pause menu
func _on_pm_visibility_changed() -> void:
  if pause_menu.visible:
    if not get_tree().paused:
      get_tree().paused = true
      print_rich("[color=MAGENTA]Menu >> [color=WHITE]Game tree has been paused.")

func _on_pm_resume() -> void:
  if get_tree().paused:
    get_tree().paused = false
    print_rich("[color=MAGENTA]Menu >> [color=WHITE]Game tree has been resumed.")


func _on_pm_settings() -> void:
  settings_menu.show()
  settings_menu.last_menu = pause_menu

func _on_pm_reset() -> void:
  get_tree().reload_current_scene()
  Grace.reset_scene()
  await Grace.scene_loaded
  pause_menu.resume_button.pressed.emit()


func _on_pm_menu() -> void:
  main_menu.show()


## Settings menu
func _on_sm_confirm() -> void:
  settings_menu.last_menu.show()


## Leaderboard menu
func _on_lm_back() -> void:
  main_menu.show()


## Win menu
func _on_wm_confirm() -> void:
  get_tree().reload_current_scene()
  Grace.reset_scene()

  leaderboard_menu.show()
  leaderboard_menu.last_menu = main_menu


func _on_leaderboard_is_inactive() ->void:
  leaderboard_menu.hide()
## General
func _input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    if not main_menu.visible and not settings_menu.visible and not leaderboard_menu.visible:
      if pause_menu.visible:
        for child in pause_menu.get_children():
          if child is Untransition:
            child.start_animation()
            break
        if get_tree().paused:
          print_rich("[color=MAGENTA]Menu >> [color=WHITE]Game tree has been resumed.")
        get_tree().paused = false
      else:
        pause_menu.show()
    elif settings_menu.visible:
      settings_menu.last_menu.show()
    elif leaderboard_menu.visible:
      main_menu.show()
