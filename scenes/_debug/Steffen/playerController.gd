extends RigidBody2D

@export var jumpForce : float = 100
@export var speed : float = 50

func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		apply_central_impulse(Vector2.UP * jumpForce)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	apply_central_force(Vector2.RIGHT * direction * speed)
	

func _on_body_entered(body: Node):
	print(body.name)