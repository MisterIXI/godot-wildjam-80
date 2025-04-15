extends Panel

@onready var vbox_container : VBoxContainer = $ScrollContainer/VBoxContainer
var highscore_entry : PackedScene =preload("res://scenes/ui/highscore_entry.tscn")

var highscore_list :Array[PanelContainer]
func _ready() -> void:
    visibility_changed.connect(_on_visible_changed)
    ## wait for getleaderboard signal
    if !ReferenceManager.highscore_node.DEBUG_MODE:
        ReferenceManager.highscore_node.leaderboard_request_completed.connect(_wait_for_finished)
    else:
        # ReferenceManager.highscore_node.set_new_highscore("oli",1,32)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)
        # ReferenceManager.highscore_node.set_new_highscore("robbi",5,3)

        _wait_for_finished()

func on_activate():
    ## delete old entries
    for x in highscore_list:
        x.queue_free()
    
    highscore_list.clear()
    ReferenceManager.highscore_node._get_leaderboards()

# on visible leaderboard, delete old ui leaderboard - instantiate new leaderboard
# if  ! debug_mode - get leaderboard from database
func _on_visible_changed() ->void:
    if visible:
        if !ReferenceManager.highscore_node.DEBUG_MODE:
            on_activate()
        else:
            for x in highscore_list:
                x.queue_free()
            highscore_list.clear()
        _wait_for_finished()

func _wait_for_finished():
    var _i  :int  =0
    for x in ReferenceManager.highscore_node.highscore_table:
        var _time_entry =  highscore_entry.instantiate() as PanelContainer
        vbox_container.add_child(_time_entry)
        highscore_list.append(_time_entry)
        _time_entry.on_initialze(str(_i), x.playername, _format(float(x.time)), "x " +str(x.collectables), x.date)
        _i +=1

func _format(_value : float)->String:
    var mseconds : float = fmod(_value,100)
    var seconds: float = fmod(_value/1000, 60.0)
    var minutes : int = int((_value / 60000)) %60
    
    var _string :String = "%02dm:%02ds:%02dms" % [minutes,seconds,mseconds]
    return _string