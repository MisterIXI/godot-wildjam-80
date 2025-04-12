extends Node

@export var disable_menu : bool = false

@export var main_menu : MainMenu
@export var pause_menu : PauseMenu
@export var settings_menu : SettingsMenu


func _ready():
  pause_menu.hide()
  settings_menu.hide()
  if disable_menu and not OS.get_name() == "HTML5":
    main_menu.hide()
  else:
    main_menu.show()
    _on_mm_visibility_changed()
  
  main_menu.visibility_changed.connect(_on_mm_visibility_changed)
  main_menu.play_button.pressed.connect(_on_mm_play)
  main_menu.settings_button.pressed.connect(_on_mm_settings)

  pause_menu.visibility_changed.connect(_on_pm_visibility_changed)
  pause_menu.resume_button.pressed.connect(_on_pm_resume)
  pause_menu.settings_button.pressed.connect(_on_pm_settings)
  pause_menu.reset_button.pressed.connect(_on_pm_reset)
  pause_menu.menu_button.pressed.connect(_on_pm_menu)

  settings_menu.confirm_button.pressed.connect(_on_sm_confirm)


## Main menu
func _on_mm_visibility_changed() -> void:
  if main_menu.visible:
    pause_menu.hide()
    settings_menu.hide()
    if not get_tree().paused:
      print_rich("[color=MAGENTA]Game tree has been paused. Origin: " + str(get_path()))
    get_tree().paused = true

func _on_mm_play() -> void:
  main_menu.hide()
  if get_tree().paused:
    print_rich("[color=CYAN]Game tree has been resumed. Origin: " + str(get_path()))
  get_tree().paused = false


func _on_mm_settings() -> void:
  main_menu.hide()
  settings_menu.show()
  settings_menu.last_menu = main_menu


## pause menu
func _on_pm_visibility_changed() -> void:
  if pause_menu.visible:
    main_menu.hide()
    settings_menu.hide()
    if not get_tree().paused:
      print_rich("[color=MAGENTA]Game tree has been paused. Origin: " + str(get_path()))
    get_tree().paused = true

func _on_pm_resume() -> void:
  pause_menu.hide()
  if get_tree().paused:
    print_rich("[color=CYAN]Game tree has been resumed. Origin: " + str(get_path()))
  get_tree().paused = false


func _on_pm_settings() -> void:
  pause_menu.hide()
  settings_menu.show()
  settings_menu.last_menu = pause_menu

func _on_pm_reset() -> void:
  get_tree().reload_current_scene()
  print_rich("[color=ORANGE]Current scene has been reloaded. Origin: " + str(get_path()))
  _on_pm_resume()
  #TODO: reset savestate

func _on_pm_menu() -> void:
  pause_menu.hide()
  main_menu.show()


## Settings menu
func _on_sm_confirm() -> void:
  settings_menu.hide()
  settings_menu.last_menu.show()


## General
func _input(event: InputEvent) -> void:
  if event.is_action_pressed("pause"):
    if not main_menu.visible and not settings_menu.visible:
      if pause_menu.visible:
        pause_menu.hide()
        if get_tree().paused:
          print_rich("[color=CYAN]Game tree has been resumed. Origin: " + str(get_path()))
        get_tree().paused = false
      else:
        pause_menu.show()
    elif settings_menu.visible:
      settings_menu.hide()
      settings_menu.last_menu.show()