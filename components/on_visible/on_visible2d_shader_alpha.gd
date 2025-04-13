extends OnVisible2d
class_name OnVisible2dShaderAlpha
## Modulates the alpha of the parents shader that containts an alpha value
@export_range(0.1, 3) var animation_duration: float = 0.3


func _on_visibility_changed():
  if parent.visible:
    parent.material.set("shader_parameter/alpha", 0.0)
    var tween = get_tree().create_tween()
    tween.set_trans(Tween.TRANS_LINEAR)
    tween.set_ease(Tween.EASE_IN)
    tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween.tween_property(parent, "material:shader_parameter/alpha", 1.0, animation_duration)

    parent.material.set("shader_parameter/drop_shadow_color", Color(0, 0, 0, 0))
    var tween_shadow = get_tree().create_tween()
    tween_shadow.set_trans(Tween.TRANS_SINE)
    tween_shadow.set_ease(Tween.EASE_IN)
    tween_shadow.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
    tween_shadow.tween_property(parent, "material:shader_parameter/drop_shadow_color", Color(0, 0, 0, 0.5), animation_duration)
