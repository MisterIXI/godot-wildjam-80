extends Node2D

var static_bodies : Array[StaticBody2D] = []
@export var player : PlayerController
func _ready():
	await get_tree().create_timer(0.1).timeout
	## old shader killer
	# for child in find_children("*", "Sprite2D"):
	# 	var sprite = child as Sprite2D
	# 	sprite.set_deferred("material", null)
	for child in find_children("*", "StaticBody2D"):
		# skip fan_obstacle scripts
		if child is FanObstacle:
			continue
		# skip childs with AnimationPlayer child
		if child.has_node("AnimationPlayer"):
			continue
		static_bodies.append(child as StaticBody2D)

func _physics_process(_delta):
	for child in static_bodies:
		var dist = child.global_position.distance_to(player.global_position)
		if dist < 3000:
			# check if already enabled
			if child.process_mode == ProcessMode.PROCESS_MODE_INHERIT:
				continue
			child.set_deferred("process_mode", ProcessMode.PROCESS_MODE_INHERIT)
			child.show()
		else:
			# check if already disabled
			if child.process_mode == ProcessMode.PROCESS_MODE_DISABLED:
				continue
			child.set_deferred("process_mode", ProcessMode.PROCESS_MODE_DISABLED)
			child.hide()