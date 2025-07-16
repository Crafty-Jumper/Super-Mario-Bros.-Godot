extends CharacterBody2D

const gravity = 10

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity
	
	else:
		if randi_range(1,250) == 1:
			velocity.y = -250
	


	move_and_slide()
