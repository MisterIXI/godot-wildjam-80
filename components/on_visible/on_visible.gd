@icon("res://components/on_visible/on_visible.png")
class_name OnVisible
extends Node
## Parent Class for the OnVisible components.

var parent
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	parent = get_parent()
	parent.visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed():
	pass