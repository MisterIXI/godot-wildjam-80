extends Area2D
@export var other_exit : Area2D
## new instance
@export var set_name_input : PackedScene

func _ready() -> void: 
    body_entered.connect(on_body_entered)
func on_body_entered(_body : Node2D) -> void:
    if _body.is_in_group("player"):
        ## CREATE INPUT BOX AND CONNECT TO CONFIRM EVENT

        Menu.win_menu.show()
        # var _new_name_input = set_name_input.instantiate()
        # add_child(_new_name_input)
        # ## set position next to area
        # _new_name_input.pressed.connect(_on_set_name_cornfirm)
        # ## disable area
        # get_tree().paused = true


func _on_set_name_cornfirm(_name : String)->void:
    ReferenceManager.highscore_node.set_new_highscore(
        _name,
        int(Session.current_run_seconds),
        Session.collectables.keys().size())
    # go to leaderboard
    Menu.leaderboard_menu.show()
    Grace.reset_scene()


#get format 00h:00m:00s
func _format(_value : float)->String:
    var _string :String
    var seconds: float = _value
    var minutes : int = int((_value / 60000)) %60
    var hours :int = int(_value /3600000)
    if hours > 0:
        _string = "%02dh:%02dm:%02ds" % [hours,minutes,seconds]
        return _string
    
    _string = "%02dm:%02ds" % [minutes,seconds]
    return _string
