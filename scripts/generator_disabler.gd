extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if floor(position.x/16)*16 == (GlobalVariables.marioTileX * 16) + (GlobalVariables.marioScreen * 256):
		GlobalVariables.generatorActive = false
