extends Node2D

@export var enemyGeneration : PackedScene
@export_enum ("Top","Bottom","Left","Right") var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if floor(position.x/16)*16 == (GlobalVariables.marioTileX * 16) + (GlobalVariables.marioScreen * 256):
		GlobalVariables.generatedEnemy = enemyGeneration
		GlobalVariables.generatorDirection = direction
		GlobalVariables.generatorActive = true
