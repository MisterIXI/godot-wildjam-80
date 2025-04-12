extends Panel

@onready var vbox_container : VBoxContainer = $VBoxContainer
@export var highscore_entry : PackedScene

var highscore_list :Array[PanelContainer]
func _ready() -> void:
    ## wait for getleaderboard signal
    ReferenceManager.highscore_node.leaderboard_request_completed.connect(_wait_for_finished)

func on_activate():
    ## delete old entries
    for x in highscore_list:
        x.queue_free()
    
    highscore_list.clear()
    ReferenceManager.highscore_node._get_leaderboards()

func _wait_for_finished():
    for x in ReferenceManager.highscore_node.highscore_table:
        var _time_entry =  highscore_entry.instantiate() as PanelContainer
        vbox_container.add_child(_time_entry)
        highscore_list.append(_time_entry)
        _time_entry.on_initialze(x.rank, x.playername, x.time, x.collectable)