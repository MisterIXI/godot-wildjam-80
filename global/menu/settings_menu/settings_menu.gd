extends Control
class_name SettingsMenu

@export var confirm_button : Button
@export var master_volume_slider : HSlider
@export var music_volume_slider : HSlider
@export var sfx_volume_slider : HSlider

var last_menu : Control

func _ready():
  _load_audio_bus_values()

  master_volume_slider.value_changed.connect(_on_master_volume_changed)
  music_volume_slider.value_changed.connect(_on_music_volume_changed)
  sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)

  visibility_changed.connect(_on_visibility_changed)


func _on_master_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100))

func _on_music_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100))

func _on_sfx_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100))
  SoundManager._make_click_sound()

func _on_visibility_changed() -> void:
  if visible:
    _load_audio_bus_values()
  else:
    Grace.save_audio_bus()

func _load_audio_bus_values() -> void:
  master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
  music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
  sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100