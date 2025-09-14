extends CharacterBody2D

@export var speed = 0
@export var jump = 0
@export var gravity = 0
@export var turnsToMushroom = false
@export_enum ("None","Hurt","Size","Powerup","Life","Invincibility") var effect = 0
@export var marioPower = 0

@onready var sprite: Node2D = $Sprite
@onready var appear_sfx: AudioStreamPlayer = $AppearSFX
@onready var flashy_part: Sprite2D = $Sprite/FlashyPart
var appearing = true
var curSpeed = 0.0

func _ready() -> void:
	sprite.position.y += 8
	appear_sfx.play()
	if turnsToMushroom:
		if GlobalVariables.marioPower < 1:
			var mush = load("res://scenes/entities/mushy.tscn").instantiate()
			mush.position = position
			get_parent().add_child(mush)
			queue_free()
		

func _physics_process(_delta: float) -> void:
	if appearing:
		sprite.position.y -= 0.25
		if sprite.position.y == 0:
			appearing = false
	
	if not is_on_floor():
		velocity.y += gravity
	
	
	
	if not appearing:
		if is_on_floor():
			velocity.y = -jump
		if velocity.x == 0:
			if curSpeed > 0:
				velocity.x = -speed
			else:
				velocity.x = speed
		else:
			curSpeed = velocity.x
	
	flashy_part.material.set_shader_parameter("accessRow",fmod(flashy_part.material.get_shader_parameter("accessRow")+1,10))
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if effect == 1:
			body.hurt()
		if effect == 2:
			if GlobalVariables.marioPower == 0:
				GlobalVariables.marioPower = 1
				GlobalVariables.marioState = -2
				body.powerup.play()
				GlobalVariables.paused = true
		if effect == 3:
			body.powerup.play()
			GlobalVariables.marioState = -5
			GlobalVariables.paused = true
			GlobalVariables.marioPower = marioPower
		if effect == 4:
			GlobalVariables.marioLives += marioPower
			body.life.play()
		if effect == 5:
			GlobalVariables.marioInvinc = 600
			body.powerup.play()
		queue_free()
