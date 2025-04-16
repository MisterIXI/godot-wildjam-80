extends Button

var disabledTextureRect: TextureRect
var signal_received := false
signal completer

func _ready() -> void:
  for child in get_children():
    if child is TextureRect:
      disabledTextureRect = child
      break

  await get_tree().create_timer(0.1).timeout

  ReferenceManager.highscore_node.leaderboard_request_completed.connect(completer.emit)
  get_tree().create_timer(5).timeout.connect(completer.emit)
  await completer

  disabled = !Schlüsseljunge.leaderboard_active
  disabledTextureRect.visible = disabled
