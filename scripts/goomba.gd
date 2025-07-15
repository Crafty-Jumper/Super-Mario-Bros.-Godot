extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var moveSpeed = 40
var speed = 0
var canMove : bool = false

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	
	if position.y > GlobalVariables.levelHeight * 16 + 48:
		queue_free()
	
	
	if GlobalVariables.paused:
		return
	
	if not canMove:
		return
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta



	if velocity.x == 0:
		if speed < 0:
			velocity.x = moveSpeed
		else:
			velocity.x = -moveSpeed
	else:
		speed = velocity.x

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not animated_sprite_2d.animation == "squish":
		if body.name == "fireball":
			queue_free()
			body.queue_free()
		if body.name == "Mario" and GlobalVariables.marioInvinc > 0:
			queue_free()
			return
		if body.name == "Mario" and body.velocity.y > 0:
			moveSpeed = 0
			velocity.x = 0
			body.velocity.y = -300
			animated_sprite_2d.animation = "squish"
			audio_stream_player_2d.play()
			animated_sprite_2d.frame = 0
		else:
			if GlobalVariables.marioInvuln > 0:
				return
			if body.name == "Mario":
				GlobalVariables.paused = true
				if GlobalVariables.marioState > 0:
					GlobalVariables.marioState = -2
					body.hurt_pipe.play()
					GlobalVariables.marioInvuln = 6 * 60
				else:
					GlobalVariables.marioState = -3
					GlobalVariables.marioLives -= 1


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "squish":
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	canMove = true
