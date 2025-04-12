extends Label



var currentCollected : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	

func incrementCollectable() -> void:	
	currentCollected += 1
	