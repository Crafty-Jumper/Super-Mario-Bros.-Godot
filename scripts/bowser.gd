extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

const gravity = 10
var health = 10

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity
	
	else:
		if randi_range(1,250) == 1:
			velocity.y = -250
	
	if health == 0:
		flip()
	


	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "fireball":
		body.explode()
		health -= 1

func flip() -> void:
	animated_sprite_2d.flip_v = true
	area_2d.queue_free()
	collision_shape_2d.disabled = true
	velocity.y = -300
