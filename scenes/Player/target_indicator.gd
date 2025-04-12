extends Sprite2D


@onready var parent: PlayerController = get_parent() as PlayerController

func _process(_delta):
	# get mouse position in world coordinates
	var mouse_pos = get_global_mouse_position()
	var mouse_dir = (mouse_pos - parent.global_position).normalized()
	# raycast in mouse direction
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		parent.global_position,
		parent.global_position + mouse_dir * parent.max_rope_distance,
	)
	query.exclude = [parent]
	var result = space_state.intersect_ray(query)
	# if result:
	# 	var dist = parent.global_position.distance_to(result.position)

	# 	global_position = parent.global_position + mouse_dir * dist / 2
	# 	rotation = mouse_dir.angle()
	# 	modulate = Color(0.0, 1.0, 0.0, 0.5)
	# 	scale = Vector2(dist, 4)
	# else:
	# 	modulate = Color(1.0, 0.0, 0.0, 0.5)
	# 	global_position = parent.global_position + mouse_dir * parent.max_rope_distance / 2
	# 	rotation = mouse_dir.angle()
	# 	scale = Vector2(parent.max_rope_distance, 4)
	if result:
		global_position = result.position
		modulate = Color(0.0, 1.0, 0.0, 0.5)
		visible = true
		pass
	else:
		# global_position = parent.global_position + mouse_dir * parent.max_rope_distance
		# modulate = Color(1.0, 0.0, 0.0, 0.5)
		visible = false
		pass
