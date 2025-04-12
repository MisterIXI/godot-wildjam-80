extends Area2D

@export var value: int = 1 

signal collected(value)

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("Player"):  # oder besser mit `is_in_group("Player")`
		collected.emit(value)
		queue_free()
