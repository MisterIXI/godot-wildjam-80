extends AnimatableBody2D
class_name FanObstacle

@export var rotation_speed: float = 1.0


func _physics_process(delta):
	rotation_degrees += rotation_speed * delta