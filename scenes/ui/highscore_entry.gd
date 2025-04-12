extends PanelContainer


@onready var rank_label : Label =$MarginContainer/HBoxContainer/value_rank
@onready var player_name_label : Label =$MarginContainer/HBoxContainer/value_playername
@onready var collectable_label : Label = $MarginContainer/HBoxContainer/value_collectables
@onready var time_label : Label =$MarginContainer/HBoxContainer/value_time

func on_initialze(_rank,_playername,_time, _collectable) ->void :
    rank_label.text = _rank
    player_name_label.text = _playername
    collectable_label.text = _collectable
    time_label.text = _time