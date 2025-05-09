extends Node2D
class_name CustomJoint

@onready var player: RigidBody2D = get_parent() as RigidBody2D
@onready var indicator_scale: Vector2 = anchor_indicator.scale
var is_active: bool = false
var length: float = 0.0
@export var anchor: Node2D = null
@export var anchor_indicator: Node2D = null
@export var sparkle: SparkleEmitter = null
@export var character_flipper: CharacterFlipper = null

func activate(target_pos: Vector2, target_body: Node2D):
	if target_body.is_in_group("MovingObstacle"):
		anchor.get_parent().remove_child(anchor)
		target_body.add_child(anchor)
		anchor_indicator.get_parent().remove_child(anchor_indicator)
		target_body.add_child(anchor_indicator)
	anchor_indicator.global_position = target_pos
	anchor_indicator.show()
	sparkle.emit_at(target_pos)
	anchor.global_position = target_pos
	is_active = true
	length = (anchor.global_position - player.global_position).length() #- 30
	anchor_indicator.global_scale = indicator_scale

func deactivate():
	anchor.get_parent().remove_child(anchor)
	add_child(anchor)
	anchor_indicator.get_parent().remove_child(anchor_indicator)
	add_child(anchor_indicator)
	is_active = false
	anchor_indicator.hide()
	anchor_indicator.global_scale = indicator_scale

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
	if is_active:
		var constraint = Vector2(-55, -35)
		if not character_flipper.facing_right:
			constraint = Vector2(35, 55)
		if player.rotation_degrees < constraint.x:
			player.apply_torque(8000)
		elif player.rotation_degrees > constraint.y:
			player.apply_torque(-8000)
	else:
		if player.rotation_degrees < -20:
			player.apply_torque(5000)
		elif player.rotation_degrees > 20:
			player.apply_torque(-5000)
