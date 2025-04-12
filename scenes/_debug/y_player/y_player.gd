extends RigidBody2D
class_name PlayerController

@export var rope: VerletRope
@export var rope_target: StaticBody2D
@export var custom_joint: CustomJoint
@export var jumpForce : float = 100
@export var max_rope_distance : float = 300

func _physics_process(_delta):
	# on move_right and move_left, apply force to the player
	if Input.is_action_pressed("move_right"):
		apply_central_force(Vector2(1000, 0))
	elif Input.is_action_pressed("move_left"):
		apply_central_force(Vector2(-1000, 0))
	if Input.is_action_just_pressed("up"):
		apply_impulse(Vector2.UP * 500)
	# on jump, apply force to the player
	if Input.is_action_just_pressed("toilette_paper"):
		# get mouse position in world coordinates
		var mouse_pos = get_global_mouse_position()
		var mouse_dir = (mouse_pos - global_position).normalized()
		# raycast in mouse direction
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + mouse_dir * max_rope_distance,
		)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			# get position of the hit point
			rope.activate(result.position)
			rope_target.global_position = result.position
			# spring_joint.node_a = rope_target.get_path()
			# pin_joint.node_b = rope_target.get_path()
			custom_joint.activate(result.position)
			# print(result.position)
	if Input.is_action_just_released("toilette_paper"):
		rope.deactivate()
		# spring_joint.node_a = ""
		# pin_joint.node_b = ""
		custom_joint.deactivate()

func _on_body_entered(body:Node):
	if body.is_in_group("Trampoline"):
		apply_central_impulse(body.transform.basis_xform(Vector2.UP) * jumpForce * 10) 