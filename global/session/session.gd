extends Node

var current_run_seconds: float = 0
var collectables : Dictionary[String, bool]

func _ready() -> void:
  reset_collectables()


func reset_collectables() -> void:
  for item in collectables:
    collectables[item] = false
  #TODO: might need to give the collectables a unique id
  #TODO: Actually set all the collectables

func set_collectables(_collectable : Dictionary[String, bool]) -> void:
  collectables = _collectable

  #TODO: Actually set all the collectables

func collect_collectable(collectable_uid: String) -> void:
  collectables[collectable_uid] = true

func _process(_delta: float) -> void:
  current_run_seconds += _delta


func reset() -> void:
  current_run_seconds = 0
  reset_collectables()
