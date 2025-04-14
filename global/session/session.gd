extends Node

var current_run_seconds: float = 0
var collectables : Dictionary[Node, bool]

func _ready() -> void:
  reset_collectables()


func reset_collectables() -> void:
  for item in get_tree().get_nodes_in_group("collectable"):
    collectables[item] = false
  #TODO: might need to give the collectables a unique id
  #TODO: Actually set all the collectables


func set_collectables(_collectables: Dictionary[Node, bool]) -> void:
  collectables = _collectables
  #TODO: Actually set all the collectables


func collect_collectable(collectable: Node2D) -> void:
  collectables[collectable] = true


func _process(_delta: float) -> void:
  current_run_seconds += _delta


func reset() -> void:
  current_run_seconds = 0
  reset_collectables()
