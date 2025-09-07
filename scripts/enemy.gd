extends CharacterBody2D

# exports
@export_enum ("Black","Red","Green") var palette: int = 0
@export_enum ("None","Walk","Bounce","Fly Horizontal","Fly Vertical") var movementType: int = 0
@export var moveSpeed = 0
@export var bounceSpeed = 0
@export var gravity = 0
@export var maxFallSpeed = 0
@export var flyDistance = 0
@export_enum ("Ignore","Stomp","Hurt Mario") var marioJumpAction = 0
@export_enum ("Ignore","Die","Fireproof") var fireballAction = 0
@export_enum ("Ignore","Die","Hurt Mario") var starAction = 0
@export var edgeTurn : bool = false
@export var winged : bool = false
@export var shellEnemy : bool = false
@export var wakeUpTime = 0
@export var shellSpeed = 0
@export var score : int = 0
@export var fireballScore : int = 0



# node references
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kick_sound: AudioStreamPlayer2D = $KickSound
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var wake_timer: Timer = $WakeTimer
@onready var edge_right: RayCast2D = $EdgeRight
@onready var edge_left: RayCast2D = $EdgeLeft

# other variables
var active : bool = false
var isInShell : bool = false
var speed = 0
var canMove : bool = true
var hasKicked : bool = false
var kick_time : int = 0
var frozen : bool = false

func _ready() -> void:
	wake_timer.wait_time = wakeUpTime

func _physics_process(delta: float) -> void:
	var d60 = delta*60
	
	if hasKicked and frozen:
		if is_on_wall():
			_projectile(load("res://scenes/shatter.tscn"),9)
			queue_free()
	
	if position.y > GlobalVariables.levelHeight * 16 + 48:
		queue_free()
	
	if frozen:
		palette = 3
		set_collision_layer_value(1,true)
	
	if animated_sprite_2d.material.get_shader_parameter("accessRow") != palette+6:
		animated_sprite_2d.material.set_shader_parameter("accessRow",palette+6)
	
	
	if kick_time > 0:
		kick_time -= 1
	
	if wake_timer.time_left < 2 and isInShell and not hasKicked:
		animated_sprite_2d.animation = "wakeUp"
	
	if not hasKicked:
		set_collision_mask_value(3,true)
	else:
		set_collision_mask_value(3,false)
	
	
	if !active:
		return
	
	if GlobalVariables.paused:
		return
	
	if animated_sprite_2d.flip_v:
		collision_shape_2d.disabled = true
	
	if not is_on_floor():
		velocity.y += gravity * d60
	
	if velocity.y > maxFallSpeed:
		velocity.y = maxFallSpeed
	
	if movementType == 1 or movementType == 2:
		if canMove:
			if velocity.x == 0:
				if speed < 0:
					velocity.x = moveSpeed
					if !frozen:
						animated_sprite_2d.flip_h = false
				else:
					velocity.x = -moveSpeed
					if !frozen:
						animated_sprite_2d.flip_h = true
			else:
				speed = velocity.x
	if hasKicked:
		if velocity.x == 0:
			if speed < 0:
				velocity.x = shellSpeed
				if !frozen:
					animated_sprite_2d.flip_h = false
			else:
				velocity.x = -shellSpeed
				if !frozen:
					animated_sprite_2d.flip_h = true
		else:
			speed = velocity.x
		
	if movementType == 2:
		if is_on_floor():
			velocity.y = -bounceSpeed * d60
	
	if edgeTurn:
		if is_on_floor():
			if !isInShell:
				if !edge_left.is_colliding():
					if velocity.x > 0:
						velocity.x *= -1
						animated_sprite_2d.flip_h = true
				if !edge_right.is_colliding():
					if velocity.x < 0:
						velocity.x *= -1
						animated_sprite_2d.flip_h = false
	
	if frozen and !hasKicked:
		velocity.x = 0
		animated_sprite_2d.speed_scale = 0
	
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("fireball"):
		if fireballAction == 1:
			flip()
			spawn_score(100)
		if fireballAction > 0:
			body.explode()
	if body.is_in_group("iceball"):
		frozen = true
		if fireballAction == 1:
			spawn_score(10)
		if fireballAction > 0:
			body.explode()
	
	if body.name == "Mario":
		if GlobalVariables.marioInvinc > 0:
			if starAction == 1:
				flip()
				return
			if starAction == 0:
				return
		
		if (isInShell or frozen) and not hasKicked:
			kick_sound.play()
			if (frozen and not(body.velocity.y > 0 or body.position.y < position.y - 9)) or isInShell:
				hasKicked = true
			wake_timer.stop()
			kick_time = 5
			if isInShell:
				animated_sprite_2d.animation = "stomp"
			if (frozen and not(body.velocity.y > 0 or body.position.y < position.y - 9)) or isInShell:
				if body.position.x > position.x:
					velocity.x = -shellSpeed
				else:
					velocity.x = shellSpeed
			return
		
		
		if animated_sprite_2d.animation == "stomp":
			if not shellEnemy:
				return
			
				
		if body.velocity.y > 0 or body.position.y < position.y - 9:
			if marioJumpAction == 1:
				if isInShell:
					if hasKicked and velocity.x == 0:
						return
				body.velocity.y = -300
				if not winged:
					animated_sprite_2d.animation = "stomp"
					canMove = false
					velocity.x = 0
					if shellEnemy:
						isInShell = true
						hasKicked = false
						wake_timer.start()
				winged = false
				spawn_score(100)
			if marioJumpAction == 2:
				body.hurt()
		else:
			if not kick_time > 0:
				body.hurt()
	
	if body.is_in_group("enemy"):
		if body.hasKicked:
			if abs(body.velocity.x) == body.shellSpeed:
				flip()
				spawn_score(200)
	
	
	

func flip() -> void:
	animated_sprite_2d.speed_scale = 0
	velocity.x = 50
	velocity.y = -250
	animated_sprite_2d.flip_v = true
	kick_sound.play()
	gravity = 30
	collision_shape_2d.set_deferred("disabled",true)
	area_2d.queue_free()


func spawn_score(amount: int) -> void:
	var scoreNum = preload("res://scenes/score.tscn")
	var scoreNode = scoreNum.instantiate()
	scoreNode.position = position
	scoreNode.score = amount
	get_parent().add_child(scoreNode)


func _on_wake_timer_timeout() -> void:
	isInShell = false
	animated_sprite_2d.animation = "default"
	canMove = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "stomp" and not shellEnemy:
		queue_free()

func _projectile(scene:PackedScene,pal:int):
	var popItem = scene.instantiate()
	popItem.position = position
	popItem.palette = pal
	GlobalVariables.add_child(popItem)
