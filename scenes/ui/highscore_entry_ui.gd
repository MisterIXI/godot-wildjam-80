extends PanelContainer


@onready var rank_label : Label =$MarginContainer/HBoxContainer/value_rank
@onready var player_name_label : Label =$MarginContainer/HBoxContainer/value_playername
@onready var collectable_label : Label = $MarginContainer/HBoxContainer/value_collectables
@onready var time_label : Label =$MarginContainer/HBoxContainer/value_time
@onready var date_label : Label =$MarginContainer/HBoxContainer/value_date
@onready var _myscore_texture : TextureRect = $myScoreTexture
@onready var _myscore_color : ColorRect = $ColorRect
var font_list :Array[Font]

func _ready() -> void:
    #select random new font
    var _new_font  = ReferenceManager.fonts[randi_range(0,ReferenceManager.fonts.size()-1)]
    ### apply new font to all entries of a row
    rank_label.add_theme_font_override("font", _new_font)
    player_name_label.add_theme_font_override("font", _new_font)
    collectable_label.add_theme_font_override("font", _new_font)
    time_label.add_theme_font_override("font", _new_font)
    date_label.add_theme_font_override("font", _new_font)

func on_initialze(_rank,_playername,_time, _collectable, _date, _playeruid) ->void :
    rank_label.text = _rank
    player_name_label.text = _playername
    collectable_label.text = _collectable
    time_label.text = _time
    date_label.text = _date
    if _playeruid != "" and PlayerUidManager.get_playeruid() == _playeruid:
        _myscore_texture.visible = true
        _myscore_color.visible  = true
