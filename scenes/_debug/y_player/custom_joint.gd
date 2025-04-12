extends Node2D
class_name CustomJoint

@export var anchor: StaticBody2D
var test : PinJoint2D
@onready var player: RigidBody2D = get_parent() as RigidBody2D
var is_active: bool = false
var length: float = 0.0
func activate():
	is_active = true
	length = (anchor.global_position - player.global_position).length() + 50
	pass

func deactivate():
	is_active = false
	pass

func _physics_process(delta):
	var dist = (anchor.global_position - player.global_position).length()
	if is_active and dist > length:
		var rope_dir = (anchor.global_position - player.global_position).normalized()
		# var constraint_dir =  
	pass

func _ready():
	pass