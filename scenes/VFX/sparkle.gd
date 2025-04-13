extends Node2D
class_name SparkleEmitter

@onready var cpu_particles_2d: CPUParticles2D = %CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = %CPUParticles2D2
@onready var cpu_particles_2d_3: CPUParticles2D = %CPUParticles2D3

func _ready() -> void:
	top_level = true
	cpu_particles_2d.one_shot = true
	cpu_particles_2d_2.one_shot = true
	cpu_particles_2d_3.one_shot = true

func emit_at(target_pos: Vector2):
	global_position = target_pos
	show()
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	cpu_particles_2d_3.emitting = true
