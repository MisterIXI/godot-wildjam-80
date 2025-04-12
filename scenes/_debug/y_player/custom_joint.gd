extends Node2D
class_name CustomJoint

@export var anchor: StaticBody2D
var test : PinJoint2D
@onready var player: RigidBody2D = get_parent() as RigidBody2D
var is_active: bool = false
var length: float = 0.0
func activate():
	is_active = true
	length = (anchor.global_position - player.global_position).length() + 50
	pass

func deactivate():
	is_active = false
	pass

func _physics_process(delta):
	var dist = (anchor.global_position - player.global_position).length()
	if is_active and dist > length:
		var rope_dir = (anchor.global_position - player.global_position).normalized()
		var constraint_dir =  Vector2(-rope_dir.y, rope_dir.x).normalized()
		var scalar_projection = (player.linear_velocity.dot(constraint_dir))
		var diff = max(0, player.linear_velocity.normalized().dot(rope_dir))
		player.linear_velocity = constraint_dir * scalar_projection
		# if diff:
		# 	print(diff)
		# 	player.apply_central_impulse(rope_dir * diff * 50)
	pass

func _ready():
	pass
