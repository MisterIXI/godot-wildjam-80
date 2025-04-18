extends Node2D

@onready var paper_sfx = $PaperSFX
@onready var flush_sfx = $FlushSFX
@onready var click_sfx = $ClickSFX

@onready var background_music = $BackgroundMusic
@onready var naddel_music = $NaddelMusic

@onready var up_sfx: AudioStreamPlayer = $UpSFX
@onready var down_sfx: AudioStreamPlayer = $DownSFX


func _flush_toilet()->void:
    flush_sfx.play()

func _make_paper_sound()->void:
    paper_sfx.play()

func _play_background_music()->void: 
    background_music.play()      

func _stop_background_music()->void: 
    background_music.stop()      

func _play_naddel_music()->void: 
    naddel_music.play()      

func _stop_naddel_music()->void: 
    naddel_music.stop()     

func _make_click_sound()->void: 
    click_sfx.play()      

func _play_up_sfx()->void:
    up_sfx.play()

func _play_down_sfx()->void:
    down_sfx.play()

func _change_to_naddel_music()->void: 
    _stop_background_music()
    _play_naddel_music()

func _change_to_background_music()->void: 
    _stop_naddel_music()
    _play_background_music()
