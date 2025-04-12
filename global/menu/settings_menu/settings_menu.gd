extends Control
class_name SettingsMenu

@export var confirm_button : Button
@export var master_volume_slider : HSlider
@export var music_volume_slider : HSlider
@export var sfx_volume_slider : HSlider
@export var ambiences_volume_slider : HSlider

var last_menu : Control

func _ready():
  master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
  music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
  sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100
  ambiences_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ambience"))) * 100

  master_volume_slider.value_changed.connect(_on_master_volume_changed)
  music_volume_slider.value_changed.connect(_on_music_volume_changed)
  sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
  ambiences_volume_slider.value_changed.connect(_on_ambiences_volume_changed)


func _on_master_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), clampf( linear_to_db(value / 100), -40, 6))

func _on_music_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), clampf( linear_to_db(value / 100), -40, 6))

func _on_sfx_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), clampf( linear_to_db(value / 100), -40, 6))
  #TODO: Play SFX click sound on change

func _on_ambiences_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), clampf( linear_to_db(value / 100), -40, 6))