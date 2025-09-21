extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.theme == 2 or GlobalVariables.theme == 4:
		animation = "underground"
