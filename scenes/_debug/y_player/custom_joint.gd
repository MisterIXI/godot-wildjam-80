extends Node2D
class_name CustomJoint

@onready var player: RigidBody2D = get_parent() as RigidBody2D
var is_active: bool = false
var length: float = 0.0
var anchor: Vector2 = Vector2.ZERO

func activate(target_pos: Vector2):
	anchor = target_pos
	is_active = true
	length = (anchor - player.global_position).length() #- 30

func deactivate():
	is_active = false

func _physics_process(_delta):
	var dist = (anchor - player.global_position).length()
	if is_active and dist > length:
		var rope_dir = (anchor - player.global_position).normalized()
		var constraint_dir =  Vector2(-rope_dir.y, rope_dir.x).normalized()
		var scalar_projection = (player.linear_velocity.dot(constraint_dir))
		player.linear_velocity = constraint_dir * scalar_projection
		# correction for overshoot and gravity step
		var overshoot = dist - length
		if overshoot > 0:
			# print("Too far: " + str(overshoot))
			player.linear_velocity += rope_dir * overshoot * 13

