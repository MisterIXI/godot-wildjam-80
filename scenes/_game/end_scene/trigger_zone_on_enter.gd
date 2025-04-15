extends Area2D
@export var cpu_particle : CPUParticles2D

func _ready() -> void:
    body_entered.connect(on_body_entered)
    body_exited.connect(on_body_exited)

func on_body_entered(_body : Node2D) ->void:
    cpu_particle.emitting  = true
func on_body_exited(_body : Node2D) ->void:
    cpu_particle.emitting  =false