extends Area2D
## PLAYER COLLECTABLE
const FAKEINT : int = 2147483647
@export var uid : int = 0
@onready var collectable_taken_scene : PackedScene = preload("res://scenes/collectable/collectable_taken.tscn")
var _minicheck :bool = false
func _ready() -> void:
    #Check if this item is allready collected in this session
    if Session.collectables.get(str(uid)):
        _spawn_token()
    else: 
        Session.collectables.set(str(uid), false)
    ## connect signal
    body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node2D) ->void:
    if body is PlayerController and !_minicheck:
        _minicheck = true
        ReferenceManager.hud.collectables = FAKEINT
        Session.collect_collectable(str(uid))
        _spawn_token()

func _spawn_token() -> void:
    var _token_taken  = collectable_taken_scene.instantiate()
    get_parent().add_child(_token_taken)
    _token_taken.global_position = global_position
    queue_free()