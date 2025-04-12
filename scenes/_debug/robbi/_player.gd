extends RigidBody2D
var _toilette_paper_scene  : PackedScene = preload("res://scenes/_debug/robbi/toilette_paper.tscn")
const TOILETTE_PAPER_RANGE : float  =400.0
const TOILETTE_PAPER_LENGTH_FACTOR : float = 0.1
const TOILETTE_PAPER_STIFFNESS :float = 100.0
const TOILETTE_DAMPING :float  = 1.0
const TOILETTE_BOOST_POWER :float =4

var _paper_joint :  DampedSpringJoint2D =null
var _line2d : Line2D = null
var is_grabbed : bool = false
var _input_direction : float = 0
### paper instance
var _current_paper_instance

func _ready() -> void:
	_current_paper_instance = _toilette_paper_scene.instantiate()
	get_tree().current_scene.add_child.call_deferred(_current_paper_instance)
	_current_paper_instance.visible  =false

func _physics_process(_delta: float) -> void:
	## if still grabbed  -> swing
	_handle_swing(_delta)
	## if in midair - fall
	## move and collide

func _input(event: InputEvent) -> void:
	## A  - D
	if  event.is_action_pressed("move_left"):
		_input_direction = -1
		_handle_moving()
	if event.is_action_released("move_left"):
		_input_direction = 0
		_handle_moving()
	if event.is_action_pressed("move_right"):
		_input_direction = 1
		_handle_moving()
	if event.is_action_released("move_right"):
		_input_direction = 0
		_handle_moving()
	## Shoot Toilette paper
	if event.is_action_pressed("toilette_paper"):
		# print("shoot toilette paper")
		if _current_paper_instance.visible:
			_remove_toilette_paper()
		
		_handle_shoot()
	
	# if event.is_action_released("toilette_paper"):
	# 	if _current_paper_instance.visible:
	# 		_remove_toilette_paper()
func _handle_moving()->void:
	apply_impulse(Vector2(-_input_direction, 0), global_position)
func _boost_to_target()->void: 
	add_constant_force((global_position.direction_to(_current_paper_instance.global_position)* TOILETTE_BOOST_POWER), global_position)
func _handle_shoot()->void : 
	var _from = global_position
	var _to = get_global_mouse_position()

	if _from.distance_to(_to) > TOILETTE_PAPER_RANGE:
		_to = _from.direction_to(_to) * TOILETTE_PAPER_RANGE + _from
	#shoot ray
	var _space_state = get_world_2d().direct_space_state
	var _result = _space_state.intersect_ray(PhysicsRayQueryParameters2D.create(_from,_to,1,[self]))

	if _result:
		## set target position
		_current_paper_instance.global_position = _result.position
		## show paper_roll
		_current_paper_instance.visible = true
		## line2d
		_line2d = Line2D.new()
		_line2d.width = 2
		_line2d.default_color = Color.BLUE_VIOLET
		_line2d.z_index =1
		get_tree().current_scene.add_child(_line2d)
		## create joint
		_paper_joint = DampedSpringJoint2D.new()
		_paper_joint.position = global_position
		_paper_joint.node_a =  self.get_path()
		_paper_joint.node_b =_current_paper_instance.get_path()
		_paper_joint.length = global_position.distance_to(_result.position) *TOILETTE_PAPER_LENGTH_FACTOR
		
		_paper_joint.stiffness = TOILETTE_PAPER_STIFFNESS
		_paper_joint.damping = TOILETTE_DAMPING

		# top level
		get_tree().current_scene.add_child(_paper_joint)
		# add little force
		_boost_to_target()
		

func _remove_toilette_paper()->void:
	if _paper_joint:
		_paper_joint.queue_free()
		_paper_joint = null
		
		_line2d.queue_free()
		_line2d = null
		
		_current_paper_instance.visible = false

func _handle_swing(_delta : float) -> void:
	if _line2d:
		_line2d.points = [global_position, _current_paper_instance.global_position]
		

