extends Area2D
@export var other_exit : Area2D
## new instance
@export var set_name_input : PackedScene

func _ready() -> void: 
    body_entered.connect(on_body_entered)
func on_body_entered(_body : Node2D) -> void:
    if _body is PlayerController:
        ## CREATE INPUT BOX AND CONNECT TO CONFIRM EVENT
        var _new_name_input = set_name_input.instantiate()
        add_child(_new_name_input)
        ## Signal to Hud - > stop Timer
        ReferenceManager.on_game_done()
        ## set position next to area
        _new_name_input.pressed.connect(_on_set_name_cornfirm)
        ## disable area
        set_deferred("monitorable",false)
        set_deferred("monitoring",false)
        set_deferred("queue_free",other_exit)
        set_deferred("queue_free",self)
        
func _on_set_name_cornfirm(_name : String)->void:
    ReferenceManager.highscore_node.set_new_highscore(
        _name,
        int(Session.current_run_seconds),
        Session.collectables.keys().size())
    # go to leaderboard
    Menu.leaderboard_menu.show()
    Grace.reset_scene()