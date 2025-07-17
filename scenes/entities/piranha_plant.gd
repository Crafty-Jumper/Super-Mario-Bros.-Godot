extends Area2D

var origY = 0
var canMove : bool = true
var moveDir = -1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origY = position.y
	position.y += 24
	animation_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= 60 * moveDir * delta
	if position.y < origY:
		position.y = origY
	if position.y > origY + 24:
		position.y = origY + 24

func moveUp() -> void:
	moveDir = -1

func moveDown() -> void:
	moveDir = 1
