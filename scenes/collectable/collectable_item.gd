extends Area2D
## PLAYER COLLECTABLE
@export var uid : int = 0
@export var available_visuals: Node2D
@export var collected_visuals: Node2D
@export var collision_shape: CollisionShape2D
var _minicheck :bool = false
var _mother : Node2D
func _ready() -> void:
    _mother = get_parent()
    reset_collectable()
    ## connect signal
    body_entered.connect(_on_body_entered)
    Session.collectables_reset.connect(reset_collectable)

func _on_body_entered(body : Node2D) ->void:
    if body is PlayerController and !_minicheck:
        _minicheck = true
        Session.collect_collectable(str(uid))
        _disable_collectable()

func reset_collectable() -> void:
    #Reset the collectable
    #Check if this item is allready collected in this session
    if Session.collectables.get(str(uid)):
        _disable_collectable()
    else: 
        Session.collectables.set(str(uid), false)
        _enable_collectable()

func _enable_collectable() -> void:
    #Enable the collectable
    collision_shape.set_deferred("disabled", false)
    available_visuals.show()
    collected_visuals.hide()
    _minicheck = false

func _disable_collectable() -> void:
    #Disable the collectable
    collision_shape.set_deferred("disabled", true)
    available_visuals.hide()
    collected_visuals.show()