extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalVariables.marioTileX * 16 + GlobalVariables.marioScreen * 256 < position.x:
		sprite_2d.flip_h = true
		velocity.x = -93.75
	else:
		velocity.x = 93.75


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	move_and_slide()
