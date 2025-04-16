extends StaticBody2D

@onready var animationplayer: AnimationPlayer = %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationplayer.play("idle")
	
	
func bounce() -> void:
	animationplayer.play("bump")
	await animationplayer.animation_finished
	animationplayer.play("idle")
