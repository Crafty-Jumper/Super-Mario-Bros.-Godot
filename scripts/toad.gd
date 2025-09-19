extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.world >= 8:
		frame = 1
