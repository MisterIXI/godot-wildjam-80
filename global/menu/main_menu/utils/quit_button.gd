extends Button
var disabledTextureRect

func _ready() -> void:
  for child in get_children():
    if child is TextureRect:
      disabledTextureRect = child
      break

  if OS.get_name() == "Web":
    disabled = true
  elif not disabled:
    disabled = false
  
  disabledTextureRect.visible = disabled

  pressed.connect(_on_pressed)


func _on_pressed() -> void:
  get_tree().quit()
  Grace.save_scene()
