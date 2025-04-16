extends PanelContainer


@onready var rank_label : Label =$MarginContainer/HBoxContainer/value_rank
@onready var player_name_label : Label =$MarginContainer/HBoxContainer/value_playername
@onready var collectable_label : Label = $MarginContainer/HBoxContainer/value_collectables
@onready var time_label : Label =$MarginContainer/HBoxContainer/value_time
@onready var date_label : Label =$MarginContainer/HBoxContainer/value_date

################ RANDOM FONT FUNCTION ############
@onready var _font_01 : FontVariation =  load("res://resources/font/Barriecito.tres")
@onready var _font_02 : FontVariation = load("res://resources/font/IBMPlexMono.tres")
@onready var _font_04: FontVariation = load("res://resources/font/Dancing_Script.tres")
@onready var _font_08: FontVariation = load("res://resources/font/Slabo_13px.tres")
@onready var _font_09: FontVariation =load("res://resources/font/UnifrakturMaguntia.tres")

var font_list :Array[Font]

func _ready() -> void:
    ## add all fonts to list
    font_list.append(_font_01)
    font_list.append(_font_02)
    font_list.append(_font_04)
    font_list.append(_font_08)
    font_list.append(_font_09)
    #select random new font
    var _new_font  = font_list[randi_range(0,font_list.size()-1)]
    ### apply new font to all entries of a row
    rank_label.add_theme_font_override("font", _new_font)
    player_name_label.add_theme_font_override("font", _new_font)
    collectable_label.add_theme_font_override("font", _new_font)
    time_label.add_theme_font_override("font", _new_font)
    date_label.add_theme_font_override("font", _new_font)

func on_initialze(_rank,_playername,_time, _collectable, _date) ->void :
    rank_label.text = _rank
    player_name_label.text = _playername
    collectable_label.text = _collectable
    time_label.text = _time
    date_label.text = _date
