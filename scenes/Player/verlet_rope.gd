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
var rope_end_pos : Vector2 = Vector2.ZERO
@export var iteration_count : int = 10
var segments : Array[VerletNode] = []
@onready var player : RigidBody2D = get_parent() as RigidBody2D
@export var tearing_particle : CPUParticles2D

var rope_throw_tween : Tween
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
	if not rope_throw_tween or not rope_throw_tween.is_running():
		segments[-1].pos = rope_anchor.global_position
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
	for i in range(segments.size()):
		rope.add_point(segments[segments.size() - 1 - i].pos)

func _physics_process(delta):
	if rope_active:
		process_rope(delta)
		
func activate(new_anchor_pos: Vector2):
	rope_active = true
	rope.show()
	init_rope()
	rope_throw_tween = create_tween()
	rope_throw_tween.tween_property(segments[-1],"pos", new_anchor_pos,0.1)

func deactivate():
	if segments.size() > 0:
		var particle_count = floor(segments.size() / 3.0)
		if particle_count > 0:
			tearing_particle.global_position = rope.global_position
			# animate tearing particle
			tearing_particle.amount = particle_count
			tearing_particle.emission_points = PackedVector2Array(rope.points)
			tearing_particle.emitting = true
	rope_active = false
	rope.set_deferred("visible", false)
	segments.clear()
	rope.points = []
	rope_anchor.global_position = global_position
