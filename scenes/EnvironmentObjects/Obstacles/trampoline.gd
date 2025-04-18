extends StaticBody2D

@onready var animationplayer: AnimationPlayer = %AnimationPlayer
@onready var bounce_sfx: AudioStreamPlayer2D = %bounce


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationplayer.play("idle")
	
	
func bounce() -> void:
	animationplayer.play("bump")
	bounce_sfx.pitch_scale = randf_range(0.8, 1.2)
	bounce_sfx.play()
	await animationplayer.animation_finished
	animationplayer.play("idle")
