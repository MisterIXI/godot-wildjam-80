extends Label

var scoreText = "WOOP WOOP"
@export var playerNode : RigidBody2D 
var startX : int

func _ready() -> void:
	text = scoreText
	startX = playerNode.global_position.x
	
func _process(_delta: float) -> void:
	var currentPos : int = (playerNode.global_position.x - startX) / 10
	if(currentPos <= 0):
		currentPos = 0
	text = str(currentPos)