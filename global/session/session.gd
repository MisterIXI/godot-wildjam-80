extends Node
signal golden_paper_enabled
signal collectables_reset
var current_run_seconds: float = 0
var collectables : Dictionary[String, bool]
var golden_paper  : bool = false
#func _ready() -> void:

  #reset_collectables()


func reset_collectables() -> void:
  for item in collectables:
    collectables[item] = false
  collectables_reset.emit()
  ReferenceManager.hud.update_collectables()

func set_gold_paper_unlocked(_bool : bool) ->void:
  golden_paper = _bool
  if golden_paper:
    golden_paper_enabled.emit()
  #if true visual

func set_collectables(_collectable : Dictionary[String, bool]) -> void:
  collectables = _collectable
  ReferenceManager.hud.update_collectables()
  _check_golden_paper()

func collect_collectable(collectable_uid: String) -> void:
  collectables[collectable_uid] = true
  ReferenceManager.hud.update_collectables()

    
    ## effect
func _process(_delta: float) -> void:
  current_run_seconds += _delta

func _check_golden_paper()->void:
  var  _collectable_count : int = 0
  for x in collectables:
    if collectables[x]:
      _collectable_count +=1
  if _collectable_count == 5:
    golden_paper = true
    #visual
    golden_paper_enabled.emit()

func reset() -> void:
  current_run_seconds = 0
  reset_collectables()
