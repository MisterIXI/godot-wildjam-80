extends Node2D

@onready var flush1_sfx = $Flush1SFX
@onready var flush2_sfx = $Flush2SFX
@onready var flush3_sfx = $Flush3SFX
@onready var flush4_sfx = $Flush4SFX
@onready var flush5_sfx = $Flush5SFX

@onready var paper1_sfx = $Paper1SFX
@onready var paper2_sfx = $Paper2SFX
@onready var paper3_sfx = $Paper3SFX

@onready var click_sfx = $ClickSFX

@onready var background_music = $BackgroundMusic
@onready var naddel_music = $NaddelMusic

@onready var flushSounds = [flush1_sfx,flush2_sfx,flush3_sfx,flush4_sfx,flush5_sfx]
@onready var paperSounds = [paper1_sfx,paper2_sfx,paper3_sfx]


func _flush_toilet()->void:
    var flush = flushSounds.pick_random()

    if flush != null:
        flush.play()

func _make_paper_sound()->void:
    var paper = paperSounds.pick_random()

    if paper != null:
        paper.play()

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

func _change_to_naddel_music()->void: 
    _stop_background_music()
    _play_naddel_music()

func _change_to_background_music()->void: 
    _stop_naddel_music()
    _play_background_music()