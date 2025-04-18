extends Node
class_name Transition

@export var wallpaper : TextureRect
@export var anything_else : Array[CanvasItem]

@export var shader_mat : ShaderMaterial = preload("res://resources/shaders/menu_transition.tres")

signal animation_finished
var _animate = false
var _parent

func _ready():
  _parent = get_parent()
  wallpaper.material = shader_mat.duplicate()
  _parent.visibility_changed.connect(_on_visibility_changed)
  animation_finished.connect(_on_animation_finished)


func _on_visibility_changed():
  if _parent.visible:
    start_animation()


func start_animation():
  for item in anything_else:
    item.visible = false

  wallpaper.material.set("shader_parameter/height", -1)
  _parent.get_parent().move_child(_parent, -1)
  _animate = true

  SoundManager._play_down_sfx()


func _process(delta: float) -> void:
  if _animate:
    var current_value : float = float(wallpaper.material.get("shader_parameter/height"))
    wallpaper.material.set("shader_parameter/height", move_toward(current_value, 1.0, delta * 2.0))

    if current_value >= 1:
      _animate = false
      animation_finished.emit()


func _on_animation_finished():
  for child in _parent.get_parent().get_children():
    if child != _parent and child is not HUDmenu:
      child.hide()

  for item in anything_else:
    item.visible = true


func stop_transition():
  _animate = false
