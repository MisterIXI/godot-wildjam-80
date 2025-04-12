extends Node2D
class_name CustomJoint

@onready var player: RigidBody2D = get_parent() as RigidBody2D
var is_active: bool = false
var length: float = 0.0
@export var anchor: Node2D = null
@export var anchor_indicator: Node2D = null


func activate(target_pos: Vector2, target_body: Node2D):
	if target_body.is_in_group("MovingObstacle"):
		anchor.get_parent().remove_child(anchor)
		target_body.add_child(anchor)
		anchor_indicator.get_parent().remove_child(anchor_indicator)
		target_body.add_child(anchor_indicator)
	anchor_indicator.global_position = target_pos
	anchor.global_position = target_pos
	is_active = true
	length = (anchor.global_position - player.global_position).length() #- 30

func deactivate():
	anchor.get_parent().remove_child(anchor)
	add_child(anchor)
	anchor_indicator.get_parent().remove_child(anchor_indicator)
	add_child(anchor_indicator)
	is_active = false

func _physics_process(_delta):
	var dist = (anchor.global_position - player.global_position).length()
	if is_active and dist > length:
		var rope_dir = (anchor.global_position - player.global_position).normalized()
		var constraint_dir =  Vector2(-rope_dir.y, rope_dir.x).normalized()
		var scalar_projection = (player.linear_velocity.dot(constraint_dir))
		player.linear_velocity = constraint_dir * scalar_projection
		# correction for overshoot and gravity step
		var overshoot = dist - length
		if overshoot > 0:
			# print("Too far: " + str(overshoot))
			player.linear_velocity += rope_dir * overshoot * 13

