extends Node2D
class_name VerletRope

# @export var rope_segments : int = 10
@export var target_length : float = 10.0
var segment_length : float = 0.0
@export var pull_strength : float = 0.1
@export var rope_active : bool = false
@export var rope: Line2D
@export var rope_anchor: Node2D
@export var rope_origin: Node2D
var anchor : Vector2 = Vector2.ZERO
var rope_end_pos : Vector2 = Vector2.ZERO
@export var iteration_count : int = 10
var segments : Array[VerletNode] = []
@onready var player : RigidBody2D = get_parent() as RigidBody2D
func _ready():
	init_rope()
	pass

func init_rope():
	segments.clear()
	var target_dir = rope_anchor.global_position - rope_origin.global_position
	var segment_count = round(target_dir.length() / target_length)
	segment_length = target_dir.length() / segment_count
	# animation shortening
	# segment_length *= 0.1
	for i in range(segment_count + 1):
		segments.append(VerletNode.new())
		segments[i].pos = rope_origin.global_position + (target_dir.normalized() * segment_length * 0.1) * i
		segments[i].prev_pos = segments[i].pos
	segments[-1].pinned = true
	rope.points = segments
	segment_length *= 0.7
	
	
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
	# apply constraints
	for i in range(iteration_count):
		for j in range(segments.size() - 1):
			if j == 0:
				segments[j].pos = rope_origin.global_position
			var seg_a = segments[j]
			var seg_b = segments[j + 1]
			
			var segment_dir = seg_b.pos - seg_a.pos
			var segment_dist = segment_dir.length()
			var segment_diff = segment_dist - segment_length
			if segment_diff > 0:
				segment_dir = segment_dir.normalized()
				if not seg_a.pinned and not seg_b.pinned:
					seg_a.pos += segment_dir * (segment_diff * 0.5)
					seg_b.pos -= segment_dir * (segment_diff * 0.5)
				elif seg_a.pinned:
					seg_b.pos -= segment_dir * segment_diff
				elif seg_b.pinned:
					seg_a.pos += segment_dir * segment_diff
	# update render line
	rope.points = []
	for seg in segments:
		rope.add_point(seg.pos)

func _physics_process(delta):
	if rope_active:
		process_rope(delta)
		
func activate(new_anchor_pos: Vector2):
	anchor = new_anchor_pos
	rope_active = true
	rope_anchor.global_position = new_anchor_pos
	rope.set_deferred("visible", true)
	init_rope()
	var tween = create_tween()
	tween.tween_property(segments[-1],"pos", anchor,0.1)

func deactivate():
	rope_active = false
	rope.set_deferred("visible", false)
	segments.clear()
	rope.points = []
	rope_anchor.global_position = global_position
	pass
