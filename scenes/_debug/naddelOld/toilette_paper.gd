extends Node2D

var swing_angle : float  = 0


func shoot(_mouse_position :  Vector2) -> void:
    var _tween  = create_tween()
    _tween.tween_property(self,"position", _mouse_position, 1.5)
    _tween.set_trans(Tween.TRANS_EXPO)
