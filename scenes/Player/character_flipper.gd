extends Node
@export var anim_duration: float = 0.3
@export var player_sprite: AnimatedSprite2D
@export var left_colliders: Array[CollisionShape2D]
@export var right_colliders: Array[CollisionShape2D]
@export var anchor_node: Node2D
@export var anchor_point_left: Node2D
@export var anchor_point_right: Node2D

var facing_right: bool = true
var anim_right_active: bool = false
var anim_left_active: bool = false
var anim_tween: Tween
@onready var sprite_scale: Vector2 = player_sprite.scale

func _physics_process(_delta):
	if Input.is_action_just_pressed("move_right"):
		on_flip_right()
	elif Input.is_action_just_pressed("move_left"):
		on_flip_left()

func on_flip_right():
	if facing_right or anim_right_active:
		return
	# Flip the player sprite to the right
	if anim_tween:
		anim_tween.kill()
		anim_right_active = false
		anim_left_active = false
	anim_right_active = true
	anim_tween = create_tween()
	anim_tween.tween_property(player_sprite,"scale", Vector2(sprite_scale.x, sprite_scale.y), anim_duration)
	anim_tween.parallel()
	anim_tween.tween_property(anchor_node,"position", anchor_point_right.position, anim_duration)
	anim_tween.tween_callback(func ():
		for collider in left_colliders:
			collider.set_deferred("disabled", false)
		for collider in right_colliders:
			collider.set_deferred("disabled", true)
		facing_right = true
		anim_right_active = false
	)
	anim_tween.play()
	pass

func on_flip_left():
	if not facing_right or anim_left_active:
		return
	# Flip the player sprite to the left
	if anim_tween:
		anim_tween.kill()
		anim_right_active = false
		anim_left_active = false
	anim_left_active = true
	anim_tween = create_tween()
	anim_tween.tween_property(player_sprite,"scale", Vector2(-sprite_scale.x, sprite_scale.y), anim_duration)
	anim_tween.parallel()
	anim_tween.tween_property(anchor_node,"position", anchor_point_left.position, anim_duration)
	anim_tween.tween_callback(func ():
		for collider in left_colliders:
			collider.set_deferred("disabled", true)
		for collider in right_colliders:
			collider.set_deferred("disabled", false)
		facing_right = false
		anim_left_active = false
	)
	anim_tween.play()
	pass
