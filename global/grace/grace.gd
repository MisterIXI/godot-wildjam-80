extends Node

@export_group("Audio Bus")
@export var reset_audio_bus_on_start : bool = false

@export_group("Scene")
@export var ignore_saved_scene : bool = false
@export var reset_scene_on_start : bool = false
@export var default_player_gloabal_position : Vector2

var _audio_bus_path = "user://audio_bus.cfg"
var _scene_path = "user://scene.cfg"

func _ready():
  if reset_audio_bus_on_start:
    reset_audio_bus()
  else:
    load_audio_bus()

  if reset_scene_on_start:
    reset_scene()
  else:
    load_scene()


#region Audio Bus
func load_audio_bus():
  var config = ConfigFile.new()
  var err = config.load(_audio_bus_path)
  if err != OK:
    print_rich("[color=CYAN]Grace >> [color=RED]Audio bus file not found!")
    reset_audio_bus()
    return

  var bus_count = AudioServer.get_bus_count()
  for i in range(bus_count):
    var bus_name = AudioServer.get_bus_name(i)
    if config.has_section_key("audio", bus_name + "_volume"):
      AudioServer.set_bus_volume_db(i, config.get_value("audio", bus_name + "_volume"))
  print_rich("[color=CYAN]Grace >> [color=WHITE]Audio bus successfully loaded from file.")


func save_audio_bus():
  var config = ConfigFile.new()

  var bus_count = AudioServer.get_bus_count()
  for i in range(bus_count):
    var bus_name = AudioServer.get_bus_name(i)
    var volume_db = AudioServer.get_bus_volume_db(i)
    config.set_value("audio", bus_name + "_volume", volume_db)

  var err = config.save(_audio_bus_path)
  if err != OK:
    print_rich("[color=CYAN]Grace >> [color=RED]Failed to save audio bus to file!")
    return
  print_rich("[color=CYAN]Grace >> [color=WHITE]Audio bus successfully saved to file.")


func reset_audio_bus():  
  var bus_count = AudioServer.get_bus_count()
  for i in range(bus_count):
    AudioServer.set_bus_volume_db(i, 0)
  print_rich("[color=CYAN]Grace >> [color=WHITE]Audio bus reset to default values.")
  save_audio_bus()


#region Scene
func load_scene():
  if ignore_saved_scene:
    return

  var config = ConfigFile.new()

  var err = config.load(_scene_path)
  if err != OK:
    print_rich("[color=CYAN]Grace >> [color=RED]Scene file not found!")
    reset_scene()
    return

  var player = get_tree().get_first_node_in_group("player")

  if config.has_section_key("player", "global_position"):
    player.global_position = config.get_value("player", "global_position")

  if config.has_section_key("player", "global_rotation"):
    player.global_rotation = config.get_value("player", "global_rotation")
  
  #TODO: New values like timer and tosses here #1

  print_rich("[color=CYAN]Grace >> [color=WHITE]Scene successfully loaded from file.")


func save_scene():
  var config = ConfigFile.new()

  config.set_value("player", "global_position", get_tree().get_first_node_in_group("player").global_position)
  config.set_value("player", "global_rotation", get_tree().get_first_node_in_group("player").global_rotation)
  #TODO: New values like timer and tosses here #2

  var err = config.save(_scene_path)
  if err != OK:
    print_rich("[color=CYAN]Grace >> [color=RED]Failed to save scene to file!")
    return
  print_rich("[color=CYAN]Grace >> [color=WHITE]Scene successfully saved to file.")


func reset_scene():
  var player = get_tree().get_first_node_in_group("player")
  player.global_position = default_player_gloabal_position
  player.global_rotation = 0
  #TODO: New values like timer and tosses here #3
  print_rich("[color=CYAN]Grace >> [color=WHITE]Scene reset to default values.")
  save_scene()


func _notification(what: int) -> void:
  if what == NOTIFICATION_WM_CLOSE_REQUEST:
    save_scene()