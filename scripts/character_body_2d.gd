extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var appear_sfx: AudioStreamPlayer2D = $AppearSFX

var moveSpeed = 60
var speed = 0
var appearing: bool = true
var raiseCount = 16
var canRaise: bool = false

func _ready() -> void:
	sprite_2d.position.y += 16


func _physics_process(delta: float) -> void:
	if GlobalVariables.paused:
		return
	
	
	
	
	
	
	

	if not appearing:
		if velocity.x == 0:
			if speed > 0:
				velocity.x = -moveSpeed
			else:
				velocity.x = moveSpeed
		else:
			speed = velocity.x
			
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			velocity.y = -320
			
	else: if canRaise:
		sprite_2d.visible = true
		sprite_2d.z_index = -1
		if raiseCount > 0:
			sprite_2d.position.y -= 0.5
			raiseCount -= 0.5
		else:
			appearing = false
			sprite_2d.z_index = 0
	else: sprite_2d.visible = false
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		body.powerup.play()
		GlobalVariables.marioInvinc = 600
		queue_free()


func _on_timer_timeout() -> void:
	canRaise = true
	appear_sfx.playing = true
