extends Panel

@onready var vbox_container : VBoxContainer = $ScrollContainer/VBoxContainer
var highscore_entry : PackedScene =preload("res://scenes/ui/highscore_entry.tscn")

var highscore_list :Array[PanelContainer]
func _ready() -> void:
    visibility_changed.connect(_on_visible_changed)

    ReferenceManager.highscore_node.leaderboard_request_completed.connect(_wait_for_finished)

func on_activate():
    ## delete old entries
    for x in highscore_list:
        x.queue_free()
    
    highscore_list.clear()
    ReferenceManager.highscore_node.get_leaderboard()
   
# on visible leaderboard, delete old ui leaderboard - instantiate new leaderboard
# if  ! debug_mode - get leaderboard from database
func _on_visible_changed() ->void:
    if visible:
            on_activate()

func _wait_for_finished():
    var _i  :int  =0
    for x in ReferenceManager.highscore_node.highscore_table:
        var _time_entry =  highscore_entry.instantiate() as PanelContainer
        vbox_container.add_child(_time_entry)
        highscore_list.append(_time_entry)
        _time_entry.on_initialze(str(_i), x.playername, ReferenceManager.format(float(x.time)), "x " +str(x.collectables), x.date)
        _i +=1
