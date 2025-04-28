extends Sprite2D
@export var line_color_active: Color = Color("ff33a3")
@export var line_color_inactive: Color = Color("51002f")
@export var color_tint_active: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var color_tint_inactive: Color = Color(0.5, 0.5, 0.5, 1.0)

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
	
	var target_move
	if result:
		target_move = result.position - global_position
		# modulate = Color(0.0, 1.0, 0.0, 0.5)
		material.set("shader_parameter/line_color", line_color_active);
		material.set("shader_parameter/color_tint", color_tint_active);
		visible = true
		pass
	else:

		var mouse_dist = (mouse_pos - parent.global_position).length()
		var target_pos = parent.global_position + mouse_dir * clampf(parent.max_rope_distance, 0.0, mouse_dist)
		target_move = target_pos - global_position
		# modulate = Color(1.0, 0.0, 0.0, 0.5)
		material.set("shader_parameter/line_color", line_color_inactive);
		material.set("shader_parameter/color_tint", color_tint_inactive);
		# visible = false
		pass
	if target_move.length() > 1:
		target_move *= 0.7
	global_position += target_move
