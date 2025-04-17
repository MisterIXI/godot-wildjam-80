extends Area2D
@export var other_exit : Area2D

func _ready() -> void: 
    body_entered.connect(on_body_entered)
func on_body_entered(_body : Node2D) -> void:
    if _body.is_in_group("player"):
        get_tree().paused = true
        Menu.win_menu.show()
