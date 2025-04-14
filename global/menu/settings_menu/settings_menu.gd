extends Control
class_name SettingsMenu

@export var confirm_button : Button
@export var master_volume_slider : HSlider
@export var music_volume_slider : HSlider
@export var sfx_volume_slider : HSlider
@export var checkbox : CheckBox
@export var isNaddelModeOn : bool


var last_menu : Control

func _ready():
  master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
  music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
  sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100
  
  master_volume_slider.value_changed.connect(_on_master_volume_changed)
  music_volume_slider.value_changed.connect(_on_music_volume_changed)
  sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
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

func _on_ambiences_volume_changed(value: float) -> void:
  AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), clampf( linear_to_db(value / 100), -40, 6))

func _on_check_box_toggled(_toggled_on:bool) -> void:
  SoundManager._make_click_sound()

  if _toggled_on: 
    isNaddelModeOn = true
    # change to circus music
    SoundManager._change_to_naddel_music()
    #TODO: naddel add timer ui element

  elif !_toggled_on: 
    isNaddelModeOn = false
    # change to background music 
    SoundManager._change_to_background_music()
    #TODO: naddel remove timer ui element 


func _is_naddel_mode_on(): 
  return isNaddelModeOn
func _on_visibility_changed() -> void:
  if visible:
    _load_audio_bus_values()
  else:
    Grace.save_audio_bus()

func _load_audio_bus_values() -> void:
  master_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))) * 100
  music_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))) * 100
  sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX"))) * 100
