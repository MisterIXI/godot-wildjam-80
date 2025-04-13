extends Node2D


@onready var cpu_particles_2d: CPUParticles2D = %CPUParticles2D
@onready var cpu_particles_2d_2: CPUParticles2D = %CPUParticles2D2
@onready var cpu_particles_2d_3: CPUParticles2D = %CPUParticles2D3

func _ready() -> void:
	top_level = true
	cpu_particles_2d.one_shot = true
	cpu_particles_2d_2.one_shot = true
	cpu_particles_2d_3.one_shot = true

func emit():
	position = get_parent().global_position
	cpu_particles_2d.emitting = true
	cpu_particles_2d_2.emitting = true
	cpu_particles_2d_3.emitting = true
