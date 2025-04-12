extends Node2D

@onready var flush1_sfx = $Flush1SFX
@onready var flush2_sfx = $Flush2SFX
@onready var flush3_sfx = $Flush3SFX
@onready var flush4_sfx = $Flush4SFX
@onready var flush5_sfx = $Flush5SFX

@onready var paper1_sfx = $Paper1SFX
@onready var paper2_sfx = $Paper2SFX
@onready var paper3_sfx = $Paper3SFX

#@onready var flush5_sfx = $Flush5SFX

#var flushSounds: Array[Object] = [flush1_sfx,flush2_sfx,flush3_sfx,flush4_sfx,flush5_sfx]
#var  := 

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