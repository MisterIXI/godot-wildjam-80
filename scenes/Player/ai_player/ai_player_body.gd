extends RigidBody2D
class_name AIPlayerController
@export var hard_impact_threshold: float = 2000
@export var rope: VerletRope
@export var rope_target: Sprite2D
@export var custom_joint: CustomJoint
@export var jumpForce: float = 100

@export var max_rope_distance: float = 300
@export var ground_cast: ShapeCast2D
@export var backup_ground_cast: RayCast2D
@export var debug_movement: bool = false

@export var hop_cd_timer: Timer
@export var naddel_ripping_timer: Timer
@export var impact_cd_timer: Timer

@export var dust_cloud_system: DustCloudParticleSystem
@export var velocity_buffer_size: int = 5

@export var manual_control: bool
@export var target_area: Area2D
@export var reward_label: Label

## aiming angle from -1 to 1
var aiming_angle: float
var left_input: bool
var right_input: bool
var hook_input: bool
var _last_hook_input: bool

var velocity_buffer: Array[float] = []
signal toilette_paper_activated
signal toilette_paper_deactivated

signal hopped_right
signal hopped_left

signal hard_impact

func is_grounded():
	return (ground_cast.is_colliding() or backup_ground_cast.is_colliding()) or debug_movement

func _physics_process(_delta):
	velocity_buffer.append(linear_velocity.length())
	if velocity_buffer.size() > velocity_buffer_size:
		velocity_buffer.pop_front()
	# rotate ground ray
	ground_cast.rotation_degrees = 360 - rotation_degrees
	backup_ground_cast.rotation_degrees = 360 - rotation_degrees
	if is_grounded() and hop_cd_timer.time_left == 0:
	# on move_right and move_left, apply force to the player
		if (manual_control and Input.is_action_pressed("move_right")) or (right_input and not left_input):
			# if Vector2.RIGHT.dot(linear_velocity) < 100:
			apply_central_impulse(Vector2(1, -1) * 100)
			hop_cd_timer.start()
			hopped_right.emit()
			dust_cloud_system.emit_at(global_position + Vector2.DOWN * 40)
			# 	apply_central_force(Vector2(500, 0))
		elif (manual_control and Input.is_action_pressed("move_left")) or (left_input and not right_input):
			# if Vector2.LEFT.dot(linear_velocity) < 100:
			apply_central_impulse(Vector2(-1, -1) * 100)
			dust_cloud_system.emit_at(global_position + Vector2.DOWN * 40)

			hop_cd_timer.start()
			hopped_left.emit()
			# 	apply_central_force(Vector2(-500, 0))
	if debug_movement and Input.is_action_just_pressed("up"):
		apply_impulse(Vector2.UP * 500)
	# on jump, apply force to the player
	if (manual_control and Input.is_action_just_pressed("toilette_paper")) or (hook_input and not _last_hook_input):
		# get mouse position in world coordinates
		var mouse_pos = get_global_mouse_position()
		var mouse_dir = (mouse_pos - global_position).normalized()
		# calc direction vector from angle
		if not manual_control:
			var rad_angle = (aiming_angle + 1) * PI
			mouse_dir = Vector2(cos(rad_angle), sin(rad_angle))
		# raycast in mouse direction
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + mouse_dir * max_rope_distance,
		)
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			custom_joint.activate(result.position, result.collider)
			rope.activate(result.position)
			rope_target.global_position = result.position
			rope_target.show()
			toilette_paper_activated.emit()
			# #Jump on grounded with toilette paper
			# if is_grounded():
			# 	apply_central_impulse((result.position - global_position) * 2)
			# print(result.position)
	if (manual_control and Input.is_action_just_released("toilette_paper")) or (not hook_input and _last_hook_input):
		if rope.rope_active:
			toilette_paper_deactivated.emit()
		rope.deactivate()
		rope_target.hide()
		# spring_joint.node_a = ""
		# pin_joint.node_b = ""
		custom_joint.deactivate()
	_last_hook_input = hook_input

func _integrate_forces(state):
	var impact_force = abs(state.linear_velocity.length() - velocity_buffer.max())
	if impact_cd_timer.time_left == 0 and state.get_contact_count() >= 1 and impact_force > hard_impact_threshold:
		dust_cloud_system.emit_at(state.get_contact_local_position(0))
		hard_impact.emit()
		impact_cd_timer.start()
		# print("IMPACT: ", impact_force, " | data: ", velocity_buffer, " ", state.linear_velocity.length())
		SoundManager._flush_toilet()

func _on_body_entered(body: Node):
	if body.is_in_group("Trampoline"):
		apply_central_impulse(body.transform.basis_xform(Vector2.UP) * jumpForce * 10)
		body.bounce()

func _ready() -> void:
	SoundManager._play_background_music()
	
