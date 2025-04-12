extends Label

@export var playerNode : RigidBody2D 
var startY : int

func _ready() -> void:
	startY = playerNode.global_position.y
	SoundManager._play_background_music()
	
func _process(_delta: float) -> void:
	var currentPos : int = (-playerNode.global_position.y + startY) / 10
	text = str(currentPos)