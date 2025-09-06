extends Sprite2D

@export var speedX : float = 0
@export var speedY : float = 0
@export var main : bool = false
var direction = 0
func _process(delta: float) -> void:
	
	rotation = floor(direction*(2/PI))/(2/PI)
	
	
	if flip_h:
		direction -= 15 * delta
	else:
		direction += 15 * delta
	
	position += Vector2(speedX,speedY) * delta * 60
	speedY += 0.5
	if speedY > 30:
		get_parent().queue_free()
