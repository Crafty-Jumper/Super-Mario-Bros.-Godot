extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.theme == 1 or GlobalVariables.theme == 3:
		animation = "underground"
