extends CharacterBody2D

@onready var head: Sprite2D = $Sprite2D/FireFlower/Head
@onready var sprite_2d: Node2D = $Sprite2D
@onready var appear_sfx: AudioStreamPlayer2D = $AppearSFX
@onready var mushroom: Sprite2D = $Sprite2D/Mushroom
@onready var fire_flower: Node2D = $Sprite2D/FireFlower

var moveSpeed = 60
var speed = 0
var appearing: bool = true
var raiseCount = 16
var canRaise: bool = false
var type = "mushroom"



func _ready() -> void:
	sprite_2d.position.y += 16
	if GlobalVariables.marioPower == 1:
		type = "fireflower"
		moveSpeed = 0


func _physics_process(delta: float) -> void:
	if type == "mushroom":
		fire_flower.hide()
	if type == "fireflower":
		mushroom.hide()
	if GlobalVariables.paused:
		return
	if type == "fireflower":
		velocity.x = 0
	
	head.material.set_shader_parameter("accessRow",fmod(head.material.get_shader_parameter("accessRow")+1,10))
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	if not appearing:
		if type == "mushroom":
			if velocity.x == 0:
				if speed > 0:
					velocity.x = -moveSpeed
				else:
					velocity.x = moveSpeed
			else:
				speed = velocity.x
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
		if GlobalVariables.marioPower == 0:
			GlobalVariables.paused = true
			GlobalVariables.marioState = -1
		if GlobalVariables.marioPower == 1:
			GlobalVariables.paused = true
			GlobalVariables.marioState = -5
		queue_free()


func _on_timer_timeout() -> void:
	canRaise = true
	appear_sfx.playing = true
