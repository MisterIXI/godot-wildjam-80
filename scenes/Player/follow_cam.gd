extends Camera2D
class_name PlayerCamera

@onready var player: RigidBody2D = get_parent() as RigidBody2D
@export var curve: Curve
@export var camera_shake_mult: float = 1.0
@export var camera_shake_max: float = 10.0
var target_zoom: Vector2 = Vector2.ONE
var shake_tween: Tween
@export var impact_shake_strength: float = 10

var shake_until: float = 0.0
@export_range(0.0, 1.0) var constant_shake: float = 0.0

func _process(delta):
	# print("Zoom: " + str(zoom), " Target Zoom: " + str(target_zoom) + " Player Speed: " + str(player.linear_velocity.length()))
	var strength = min(1.0, max(0.0, player.linear_velocity.length() / 1500))

	target_zoom = Vector2.ONE - Vector2.ONE * min(1.0, max(0.0, curve.sample(strength)))
	# smooth move to target zoom
	if zoom.distance_to(target_zoom) < 0.001:
		zoom = target_zoom
	else:
		if zoom.length() > target_zoom.length():
			# on zoom out
			zoom = zoom.move_toward(target_zoom, zoom.distance_to(target_zoom) * 0.5 * delta)
		else:
			# on zoom in
			zoom = zoom.move_toward(target_zoom, zoom.distance_to(target_zoom) * 1.5 * delta)

		var speed_shake = max(0.0, 0.8 - zoom.x) * 2 * 10
		var shake = Vector2(
			(randf_range(-1.0, 1.0) * camera_shake_mult * (constant_shake + speed_shake)),
			(randf_range(-1.0, 1.0) * camera_shake_mult * (constant_shake + speed_shake))
		)
		offset += shake
		# clamp offset to max shake
		offset.x = clamp(offset.x, -camera_shake_max, camera_shake_max)
		offset.y = clamp(offset.y, -camera_shake_max, camera_shake_max)
		if constant_shake + speed_shake == 0.0:
			offset = Vector2.ZERO

func _on_hard_impact():
	if shake_tween:
		shake_tween.kill()
	constant_shake = impact_shake_strength
	shake_tween = create_tween()
	shake_tween.tween_interval(0.2)
	shake_tween.tween_property(self,"constant_shake", 0.0, 0.3)

func reset():
	target_zoom = Vector2.ONE
	zoom = Vector2.ONE
	position = Vector2.ZERO
	position_smoothing_enabled = false
	set_deferred("position_smoothing_enabled", true)