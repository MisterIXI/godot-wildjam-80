extends AnimatedSprite2D
var _animation_throw : String =  "throw"

func _change_to_golden_paper() ->void: 
	_animation_throw = "gold_throw"

func _ready() -> void:
	Session.golden_paper_enabled.connect(_change_to_golden_paper)
	if Session.golden_paper:
		_change_to_golden_paper()

func _on_start_throw():
		animation = _animation_throw

func _on_end_throw():
	animation = "default"
