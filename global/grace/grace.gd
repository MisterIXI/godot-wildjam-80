extends Node

@export var reset_audio_bus_on_start : bool = false
var _audio_but_path = "user://audio_bus.cfg"

func _ready():
  if reset_audio_bus_on_start:
    reset_audio_bus()
  else:
    load_audio_bus()


func load_audio_bus():
  var config = ConfigFile.new()
  var err = config.load(_audio_but_path)
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

  var err = config.save(_audio_but_path)
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
