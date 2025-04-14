extends Node2D
class_name DustCloudParticleSystem

@export var particles: Array[CPUParticles2D]


func emit_at(target_pos: Vector2):
	# duplicate self at position and emit particles
	var dup = self.duplicate()
	get_parent().add_child(dup)
	dup.position = target_pos
	for particle in dup.particles:
		particle.emitting = true
	get_tree().create_timer(particles[0].lifetime).timeout.connect(dup.queue_free)
