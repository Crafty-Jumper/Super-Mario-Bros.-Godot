extends Area2D

var origY = 0
var canMove : bool = true
@export var moveDir = 1
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origY = position.y
	position.y += 24
	timer.start(2)

func _process(delta: float) -> void:
	
	position.y -= 60*moveDir * delta
	
	if position.y < origY:
		position.y = origY
	if position.y > origY + 24:
		position.y = origY + 24

func moveUp() -> void:
	moveDir = -1

func moveDown() -> void:
	moveDir = 1


func _on_timer_timeout() -> void:
	if moveDir == -1:
		moveDir = 1
		timer.start(2)
	if moveDir == 1:
		moveDir = -1
		timer.start(4)
