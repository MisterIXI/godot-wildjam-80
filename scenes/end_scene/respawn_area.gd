extends Area2D

@export var _player : RigidBody2D
var _startpos : Vector2  = Vector2.ZERO
func _ready() -> void:
    _startpos =  _player.global_position

func on_body_entered(_body : Node2D) -> void:
   _body.global_position = _startpos