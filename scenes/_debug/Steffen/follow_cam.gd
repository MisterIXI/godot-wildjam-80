extends Camera2D

@onready var player: RigidBody2D = get_parent() as RigidBody2D
@export var curve: Curve

var target_zoom: Vector2 = Vector2.ONE

func _process(delta):
	print("Zoom: " + str(zoom), " Target Zoom: " + str(target_zoom) + " Player Speed: " + str(player.linear_velocity.length()))
	var strength = min(1.0, max(0.0, player.linear_velocity.length() / 1500))

	target_zoom = Vector2.ONE - Vector2.ONE * min(1.0, max(0.0, curve.sample(strength)))
	# smooth move to target zoom
	if zoom.distance_to(target_zoom) < 0.001:
		zoom = target_zoom
	else:
		if zoom.length() > target_zoom.length():
			# on zoom out
			zoom = zoom.move_toward(target_zoom, zoom.distance_to(target_zoom) * 0.5 *  delta)
		else:
			# on zoom out
			zoom = zoom.move_toward(target_zoom, zoom.distance_to(target_zoom) * 1.5 * delta)
