extends CharacterBody2D

var jumpFrames = 0
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	jumpFrames -= 1
	if jumpFrames < 0:
		velocity.y = 20
		velocity.x = 0
		sprite_2d.frame = 1
	else:
		velocity.y -= 10
		sprite_2d.frame = 0
		if GlobalVariables.marioTileX * 16 < fmod(position.x,256):
			velocity.x = velocity.y
		else:
			velocity.x = -velocity.y
	
	if (GlobalVariables.marioTileY - 2) * 16 < position.y:
		if jumpFrames < -30:
			jumpFrames = 20
	move_and_slide()
