extends Node
class_name Untransition

@export var wallpaper : TextureRect
@export var anything_else : Array[CanvasItem]

@export var shader_mat : ShaderMaterial = preload("res://resources/shaders/menu_transition.tres")
@export var _activator : Array[Button]

signal animation_finished
var _animate = false
var _parent

var _transition_sibling : Transition

func _ready():
  _parent = get_parent()
  wallpaper.material = shader_mat.duplicate()
  for button in _activator:
    button.pressed.connect(start_animation)
  animation_finished.connect(_on_animation_finished)

  for child in _parent.get_children():
    if child is Transition:
      _transition_sibling = child
      break


func start_animation():
  _transition_sibling.stop_transition()

  for item in anything_else:
    item.visible = false
  _animate = true

  SoundManager._play_up_sfx()


func _process(delta: float) -> void:
  if _animate:
    var current_value : float = float(wallpaper.material.get("shader_parameter/height"))
    wallpaper.material.set("shader_parameter/height", move_toward(current_value, -1, delta * 2.0))

    if current_value <= -1:
      _animate = false
      animation_finished.emit()


func _on_animation_finished():
  _parent.hide()
