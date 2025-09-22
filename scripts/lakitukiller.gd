extends Node2D


# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	if floor(position.x/16)*16 == (GlobalVariables.marioTileX * 16) + (GlobalVariables.marioScreen * 256):
		GlobalVariables.lakituActive = false
