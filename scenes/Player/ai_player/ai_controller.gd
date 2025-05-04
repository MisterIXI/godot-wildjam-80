extends AIController2D
class_name CustomAIController


@onready var player: AIPlayerController = get_parent()
@export var ray_sensor: RaycastSensor2D
@export var stack_frame_count: int = 5
@export var character_flipper: CharacterFlipper
var _stack_frames: Array[Array] = []
var is_success: bool = false
var closest_distance: float = 0.0
var last_rewards: Array[float] = []
var max_dist: float

@onready var start_pos: Vector2 = player.global_position
func get_obs() -> Dictionary:
	var obs: Array[float] = []
	# player vel
	obs.append_array([
		player.linear_velocity.x,
		player.linear_velocity.y,
		player.rotation_degrees / 360.0,
		1.0 if player.is_grounded() else 0.0,
		1.0 if player.hook_input else 0.0,
	])
	var target_rel = player.to_local(player.target_area.global_position)
	obs.append_array([
		target_rel.x / 1000.0,
		target_rel.y / 1000.0,
	])
	obs.append_array(ray_sensor.get_observation())
	_stack_frames.push_front(obs)
	if _stack_frames.size() < stack_frame_count:
		while _stack_frames.size() < stack_frame_count:
			_stack_frames.push_front(_stack_frames[0])
	if _stack_frames.size() > stack_frame_count:
		_stack_frames.pop_back()
	return {"obs": obs}


func get_reward() -> float:
	var new_dist = player.global_position.distance_to(player.target_area.global_position)
	if new_dist < closest_distance:
		reward += (closest_distance - new_dist) / 100.0 * (1.0 - new_dist / max_dist)
		closest_distance = new_dist
	last_rewards.push_front(reward)
	if last_rewards.size() > 20:
		last_rewards.pop_back()
	var avg_reward = 0.0
	for r in last_rewards:
		avg_reward += r
	avg_reward /= last_rewards.size()
	player.reward_label.text = "avg_reward: %.2f | last_reward: %.2f" % [avg_reward, reward]
	return reward


func get_action_space() -> Dictionary:
	return {
		"aiming_angle": {"size": 1, "action_type": "continuous"},
		"moveL": {"size": 1, "action_type": "discrete"},
		"moveR": {"size": 1, "action_type": "discrete"},
		"hook": {"size": 1, "action_type": "discrete"},
	}

func get_info() -> Dictionary:
	if done:
		return {
			"is_success": is_success,
		}
	return {}

func set_action(action) -> void:
	player.aiming_angle = action["aiming_angle"][0]
	player.left_input = action["moveL"] == 1
	player.right_input = action["moveR"] == 1
	player.hook_input = action["hook"] == 1

func reset():
	n_steps = 0
	needs_reset = false
	player.left_input = false
	player.right_input = false
	player.hook_input = false
	player.aiming_angle = 0.0
	_stack_frames = []
	player.global_position = start_pos
	player.linear_velocity = Vector2.ZERO
	player.rotation_degrees = 0.0
	character_flipper.on_flip_right()
	closest_distance = player.global_position.distance_to(player.target_area.global_position)
	max_dist = closest_distance
	done = true

func _physics_process(_delta):
	n_steps += 1
	if n_steps > reset_after:
		needs_reset = true
	if needs_reset:
		reset()


func _on_area_monitor_area_entered(area: Area2D):
	if area.is_in_group("TargetArea"):
		print("TargetArea entered")
		is_success = true
		needs_reset = true
		done = true
		reward += 1.0
	elif area.is_in_group("DeathArea"):
		print("DeathArea entered")
		is_success = false
		needs_reset = true
		done = true
