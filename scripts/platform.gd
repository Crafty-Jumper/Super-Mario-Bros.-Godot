extends CharacterBody2D

@export var speed = 60
@export_enum ("None","WrapDown","WrapUp","Fall","Right") var moveType = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if moveType == 1:
		velocity.y = speed
		if position.y > GlobalVariables.levelHeight * 16:
			position.y = -8
	if moveType == 2:
		velocity.y = -speed
		if position.y < -8:
			velocity.y = 0
			position.y = GlobalVariables.levelHeight * 16
		
	move_and_slide()
