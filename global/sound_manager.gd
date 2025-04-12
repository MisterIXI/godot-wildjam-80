extends Node2D

@onready var flush1_sfx = $Flush1SFX
@onready var flush2_sfx = $Flush2SFX
@onready var flush3_sfx = $Flush3SFX
@onready var flush4_sfx = $Flush4SFX
@onready var flush5_sfx = $Flush5SFX

@onready var paper_sfx = $PaperSFX
@onready var background_music = $BackgroundMusic

@onready var flushSounds = [flush1_sfx,flush2_sfx,flush3_sfx,flush4_sfx,flush5_sfx]


func _flush_toilet()->void:
    var flush = flushSounds.pick_random()

    if flush != null:
        flush.play()

func _make_paper_sound()->void:
    #var paper = paperSounds.pick_random()
    paper_sfx.play()

   #if paper != null:
       # paper.play()

func _play_background_music()->void: 
    background_music.play()      

func _stop_background_music()->void: 
    background_music.stop()      