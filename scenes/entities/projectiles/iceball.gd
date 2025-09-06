extends CharacterBody2D


const JUMP_VELOCITY = -150
const gravity = 300
var jumped : bool = false

@onready var fireball: Sprite2D = $Fireball
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var exploding : bool = false
var direction = 0

func _physics_process(delta: float) -> void:
	
	rotation = floor(direction*(2/PI))/(2/PI)
	
	direction += 15 * delta
	
	if exploding:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if not jumped:
			velocity.y += JUMP_VELOCITY
			jumped = true
		else:
			explode()
	
	if is_on_wall():
		explode()
	
	if position.y > GlobalVariables.levelHeight * 16 + 48:
		queue_free()

	move_and_slide()
	
	


func explode() -> void:
	animated_sprite_2d.play("default")
	fireball.visible = false
	animated_sprite_2d.visible = true
	exploding = true

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
