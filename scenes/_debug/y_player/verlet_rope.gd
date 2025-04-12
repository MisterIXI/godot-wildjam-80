extends Node2D
class_name VerletRope

# @export var rope_segments : int = 10
@export var target_length : float = 10.0
var segment_length : float = 0.0
@export var pull_strength : float = 0.1
@export var rope_active : bool = false
@export var rope: Line2D
@export var rope_anchor: Node2D
@export var iteration_count : int = 10
var segments : Array[VerletNode] = []
@export var player : RigidBody2D = get_parent() as RigidBody2D
func _ready():
	init_rope()
	pass

func init_rope():
	segments.clear()
	var target_dir = rope_anchor.global_position - player.global_position
	var segment_count = round(target_dir.length() / target_length)
	segment_length = target_dir.length() / segment_count
	for i in range(segment_count + 1):
		segments.append(VerletNode.new())
		segments[i].pos = player.global_position + (target_dir.normalized() * segment_length) * i
		segments[i].prev_pos = segments[i].pos
	segments[-1].pinned = true
	rope.points = segments
	
	
func process_rope(delta: float):
	# go through all segments and apply velocity + gravity
	for i in range(segments.size() - 1):
		if segments[i].pinned:
			continue
		var seg = segments[i]
		var vel = seg.pos - seg.prev_pos
		var new_pos = seg.pos + vel + Vector2(0, 9.8) * delta
		seg.prev_pos = seg.pos
		seg.pos = new_pos
	# segments[0].pos += player.linear_velocity * delta

	# apply constraints
	for i in range(iteration_count):
		for j in range(segments.size() - 1):
			if j == 0:
				segments[j].pos = player.global_position
				# continue
			var seg_a = segments[j]
			var seg_b = segments[j + 1]
			
			var dir = seg_b.pos - seg_a.pos
			var dist = dir.length()
			var diff = dist - segment_length
			if diff > 0:
				dir = dir.normalized()
				if not seg_a.pinned and not seg_b.pinned:
					seg_a.pos += dir * (diff * 0.5)
					seg_b.pos -= dir * (diff * 0.5)
				elif seg_a.pinned:
					seg_b.pos -= dir * diff
				elif seg_b.pinned:
					seg_a.pos += dir * diff
		var dir = segments[0].pos - player.global_position
		var dist = dir.length()
		var diff = dist - segment_length
		if diff > 0:
			dir = dir.normalized()
			# segment[0].pos += dir * diff
			

	# update render line
	rope.points = []
	for seg in segments:
		rope.add_point(seg.pos)
	
	# move parent rigidbody
	# var rope_head = segments[0].pos
	# var to_rope = rope_head - player.global_position
	# player.apply_central_force(to_rope * pull_strength)
	player.linear_velocity += (segments[0].pos - player.global_position) * 100
	player.global_position = segments[0].pos

	# player.apply_central_force(((segments[0].pos + global_position) - player.global_position) * pull_strength)
	pass

func _physics_process(delta):
	if rope_active:
		process_rope(delta)
		
func activate(new_anchor_pos: Vector2):
	rope_active = true
	rope_anchor.global_position = new_anchor_pos
	rope.set_deferred("visible", true)
	init_rope()

func deactivate():
	rope_active = false
	rope.set_deferred("visible", false)
	segments.clear()
	rope.points = []
	rope_anchor.global_position = global_position
	pass
