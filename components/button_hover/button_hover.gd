extends Node
class_name ButtonHover

@export var scale_mult : float = 1.1
@export var animation_time : float = 0.2

var base_scale
var parent
var tween : Tween

func _ready():
  process_mode = PROCESS_MODE_ALWAYS
  parent = get_parent()
  parent.mouse_entered.connect(_on_mouse_entered)
  parent.mouse_exited.connect(_on_mouse_exited)
  base_scale = parent.scale

  parent.tree_entered.connect(_check_cursor_inside)
  parent.visibility_changed.connect(_check_cursor_inside)


func _on_mouse_entered():
  if parent.disabled:
    return
  if tween:
    tween.kill()
  tween = get_tree().create_tween()
  tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
  tween.set_trans(Tween.TRANS_LINEAR)
  tween.set_ease(Tween.EASE_IN_OUT)
  tween.tween_property(parent, "scale", parent.scale * scale_mult, ((parent.scale / base_scale).length() * scale_mult) * animation_time)



func _on_mouse_exited():
  if parent.disabled:
    return
  if tween:
    tween.kill()
  tween = get_tree().create_tween()
  tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
  tween.set_trans(Tween.TRANS_LINEAR)
  tween.set_ease(Tween.EASE_IN_OUT)
  tween.tween_property(parent, "scale", base_scale, ((parent.scale / base_scale).length() * scale_mult) * animation_time)


func _check_cursor_inside() -> void:
  if parent.get_global_rect().has_point(parent.get_global_mouse_position()):
    _on_mouse_entered()
  else:
    _on_mouse_exited()
