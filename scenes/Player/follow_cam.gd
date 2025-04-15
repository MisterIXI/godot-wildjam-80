extends Camera2D
class_name PlayerCamera
@onready var player: RigidBody2D = get_parent() as RigidBody2D
@export var zoom_curve: Curve
@export var speedline_curve: Curve
@export var speedshake_curve: Curve
@export var camera_shake_mult: float = 1.0
@export var camera_shake_max: float = 10.0
var target_zoom: Vector2 = Vector2.ONE
var shake_tween: Tween
@export var impact_shake_strength: float = 10
@export var speedline_rect: ColorRect
@onready var current_strength: float = zoom.x
var shake_until: float = 0.0
@export_range(0.0, 1.0) var constant_shake: float = 0.0

func _process(delta):
	# print("Zoom: " + str(zoom), " Target Zoom: " + str(target_zoom) + " Player Speed: " + str(player.linear_velocity.length()))
	var strength = min(1.0, max(0.0, (player.linear_velocity.length()) / 2000))
	#print("Speed: " + str(player.linear_velocity.length()), " Strength: " + str(strength))
	if strength > current_strength:
		# when faster --> zoom out
		current_strength = move_toward(current_strength, strength, delta * 0.5)
	else:
		# when slower --> zoom in
		current_strength = move_toward(current_strength, strength, delta * 1)
	zoom = Vector2.ONE * zoom_curve.sample(current_strength)
	speedline_rect.material.set("shader_parameter/line_density", speedline_curve.sample(current_strength))
	var speed_shake = speedshake_curve.sample(current_strength)
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
	current_strength = 0.0
	set_deferred("position_smoothing_enabled", true)