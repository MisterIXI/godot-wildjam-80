extends Area2D
@export var other_exit : Area2D
## new instance
@export var set_name_input : PackedScene

func on_body_entered(_body : Node2D) -> void:
    if _body is PlayerController:
        ## CREATE INPUT BOX AND CONNECT TO CONFIRM EVENT
        var _new_name_input = set_name_input.instantiate()
        add_child(_new_name_input)
        ## set position next to area
        _new_name_input.pressed.connect(_on_set_name_cornfirm)

func _on_set_name_cornfirm()->void:
    ReferenceManager.highscore_node.set_new_highscore("_name",ReferenceManager.hud.get_timer_score(),ReferenceManager.hud.get_collectable_score())
    # go to leaderboard
    ReferenceManager.game_manager.change_level(0)
    ## disable area
    monitorable = false
    monitoring = false
    other_exit.queue_free()
    