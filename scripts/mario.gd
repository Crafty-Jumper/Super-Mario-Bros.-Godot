extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var big_jump: AudioStreamPlayer = $BigJump
@onready var timer: Timer = $Timer
@onready var small_jump: AudioStreamPlayer = $SmallJump
@onready var ColDown: CollisionShape2D = $ColDown
@onready var ColUp: CollisionShape2D = $ColUp
@onready var dead_music: AudioStreamPlayer = $DeadMusic
@onready var powerup: AudioStreamPlayer = $Powerup
@onready var hurt_pipe: AudioStreamPlayer = $"Hurt&Pipe"
@onready var coin_sfx: AudioStreamPlayer = $CoinSFX
@onready var swim_sfx: AudioStreamPlayer = $SwimSFX
@onready var life: AudioStreamPlayer = $Life

var physicsFile = FileAccess.open("res://physics.json",FileAccess.READ)
var physicsString = physicsFile.get_as_text()
var physics = JSON.parse_string(physicsString)
var direction = 0
var yDir = 0
var throwFrames = 0
var frameTimer = 0

signal goal_pole

var goal_walk : bool = false
var slidingOnPole : bool = false

const gravityDie = 750

# basic variables
var maxSpeed = 0
var minSpeed = 0
var jumpSpeed = 0
var gravity = 0
var accel = 0
var decel = 0
var jumpStartSpeed = 0
var maxFall = 240

var inputAffects : bool = true
var debug : bool = false
var canPipe : bool = false
var isPipe : bool = false
var fireball : PackedScene = load("res://scenes/entities/projectiles/fireball.tscn")
var isDrain : bool = false
var climbedDist = 0

func _ready() -> void:
	physicsFile.close()

func _physics_process(delta: float) -> void:
	# updating the physics
	_physics_update()
	
	if frameTimer > 0:
		frameTimer -= 1
	else:
		frameTimer = 5
	
	if GlobalVariables.intermission:
		inputAffects = false
		direction = 1
	
	if GlobalVariables.marioClimbing:
		inputAffects = false
		set_collision_mask_value(1,false)
		if yDir == 0:
			return
		if climbedDist < 140:
			z_index = -127
			climbedDist += 1
			if climbedDist >= 100:
				yDir = 0
				if climbedDist == 100:
					animated_sprite_2d.flip_h = true
					position.x += 16
		else:
			set_collision_mask_value(1,true)
			z_index = 0
			position.x += 4
			inputAffects = true
			gravity = physics["gravStand"]
			GlobalVariables.marioClimbing = false
	
	if GlobalVariables.marioVine:
		if position.y < -15:
			_changeRoom()
			GlobalVariables.enteringVine = true
	
	canPipe = get_meta("canPipe")
	GlobalVariables.marioScreen = floor(position.x/256)
	GlobalVariables.marioTileX = int(fmod(position.x/16,16))
	GlobalVariables.marioTileY = int(position.y/16)
	
	
	if GlobalVariables.marioInvinc == 0:
		if GlobalVariables.marioPower == 2:
			animated_sprite_2d.material.set_shader_parameter("accessRow",2)
		else: if GlobalVariables.marioPower == 3:
			animated_sprite_2d.material.set_shader_parameter("accessRow",4)
		else:
			animated_sprite_2d.material.set_shader_parameter("accessRow",1)
	
	
	if canPipe:
		if is_on_floor() and get_meta("pipeDirection") < 3:
			if yDir < 0 and get_meta("pipeDirection") == 0:
				isPipe = true
				hurt_pipe.play()
			if direction > 0 and get_meta("pipeDirection") == 1:
				isPipe = true
				hurt_pipe.play()
			if direction < 0 and get_meta("pipeDirection") == 2:
				isPipe = true
				hurt_pipe.play()
	if isPipe:
		if GlobalVariables.pipes[GlobalVariables.marioScreen] is Array:
			Music.loadtrack("None")
		set_meta("canPipe",false)
		animated_sprite_2d.speed_scale = 1
		if get_meta("pipeDirection") == 0:
			position.y += 1
		if get_meta("pipeDirection") == 1:
			if timer.time_left > 1:
				position.x += 0.25
		if get_meta("pipeDirection") == 2:
			if timer.time_left > 1:
				position.x -= 0.25
		z_index = -127
		if timer.time_left == 0:
			timer.start(2)
		return
	
	if inputAffects:
		direction = Input.get_axis("left", "right")
		yDir = Input.get_axis("down","up")
	
	if fmod(floor(GlobalVariables.marioInvuln),2) == 1:
		hide()
	else:
		show()
	
	if Input.is_action_just_pressed("freefly"):
		if debug:
			debug = false
		else:
			debug = true
	
	if debug:
		if direction:
			position.x += 8 * direction
		if Input.get_axis("up","down"):
			position.y += 8 * Input.get_axis("up","down")
		return
	
	if GlobalVariables.marioState == -1:
		if GlobalVariables.marioSize == 1:
			animated_sprite_2d.animation = "shrink"
		else:
			animated_sprite_2d.animation = "grow"
		animated_sprite_2d.speed_scale = 1
		GlobalVariables.marioPower = 1
		return
	
	if GlobalVariables.marioState == -2:
		if GlobalVariables.marioSize == 1:
			animated_sprite_2d.animation = "shrink"
		else:
			animated_sprite_2d.animation = "grow"
		animated_sprite_2d.speed_scale = 1
		return
	
	if GlobalVariables.marioState == -3:
		animated_sprite_2d.animation = "die"
		ColDown.disabled = true
		ColUp.disabled = true
		if timer.time_left == 0:
			dead_music.play()
			timer.start()
		return
	
	if GlobalVariables.marioState == -4:
		GlobalVariables.marioScreen = 0
		animated_sprite_2d.animation = "die"
		velocity.y += gravityDie * delta
		move_and_slide()
		if position.y > GlobalVariables.levelHeight * 16 + 3000:
			if GlobalVariables.marioLives > 0:
				get_tree().change_scene_to_file("res://scenes/loading1.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/loading2.tscn")
		return

	if position.y > GlobalVariables.levelHeight * 16 + 100:
		if GlobalVariables.bonus:
			if position.y > GlobalVariables.levelHeight * 16 + 500:
				_changeRoom()
		else:
			if not dead_music.playing:
				dead_music.play()
				GlobalVariables.marioState = -3

	if GlobalVariables.marioState == -5:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/8))
		if timer.is_stopped():
			timer.start(1)
		return
	
	if GlobalVariables.marioInvinc > 60:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/2))
	if GlobalVariables.marioInvinc < 60 and GlobalVariables.marioInvinc > 0:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/64))
	
	
	
	if GlobalVariables.marioSize == 0:
		ColUp.disabled = true
	else:
		ColUp.disabled = false
	
	
	
	if not slidingOnPole or GlobalVariables.marioVine:
		animated_sprite_2d.speed_scale = abs(velocity.x/physics["maxWalk"])
		if animated_sprite_2d.speed_scale < 0.5:
			animated_sprite_2d.speed_scale = 0.5
		if GlobalVariables.underwater:
			animated_sprite_2d.speed_scale = 1
		if is_on_floor():
			if not velocity.x == 0 or direction:
				animated_sprite_2d.animation = "walk" + GlobalVariables.marioVisual
			else:
				animated_sprite_2d.animation = "idle" + GlobalVariables.marioVisual
			if velocity.x * direction < 0:
				animated_sprite_2d.animation = "turn" + GlobalVariables.marioVisual
				if frameTimer == 5:
					var popItem = load("res://scenes/smoke.tscn").instantiate()
					popItem.position = position
					popItem.position.y += 16
					get_parent().add_child(popItem)
		else:
			if GlobalVariables.underwater:
				if not animated_sprite_2d.animation == "swim" + GlobalVariables.marioVisual:
					animated_sprite_2d.animation = "swimIdle" + GlobalVariables.marioVisual
			else:
				animated_sprite_2d.animation = "jump" + GlobalVariables.marioVisual
		
		
	if not animated_sprite_2d.is_playing():
		animated_sprite_2d.play()
	
	if not is_on_floor():
		if not GlobalVariables.marioVine:
			velocity.y += gravity * delta
	
	
	if velocity.y > maxFall:
		velocity.y = maxFall
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or GlobalVariables.underwater):
		velocity.y = -jumpSpeed
		if GlobalVariables.underwater:
			swim_sfx.play()
		else:
			if GlobalVariables.marioSize:
				big_jump.play()
			else:
				small_jump.play()
	
	if ((not GlobalVariables.underwater) and is_on_floor()) or GlobalVariables.underwater:
		if direction < 0 and is_on_floor():
			animated_sprite_2d.flip_h = true
		if direction > 0 and is_on_floor():
			animated_sprite_2d.flip_h = false
	
	if not GlobalVariables.marioVine:
		if is_on_floor():
			jumpStartSpeed = abs(velocity.x)
			if direction:
				if abs(direction) > 0:
					velocity.x += direction * accel * delta
				else:
					velocity.x += direction * decel * delta
			else:
				velocity.x = move_toward(velocity.x, 0, decel * delta)
		else:
			if direction == velocity.x/abs(velocity.x):
				pass
			
			if direction:
				velocity.x += direction * accel * delta
	else:
		if not animated_sprite_2d.animation == "climb" + GlobalVariables.marioVisual:
			animated_sprite_2d.animation = "climb" + GlobalVariables.marioVisual
		velocity.x = 0
		if yDir == 0:
			animated_sprite_2d.speed_scale = 0
		else:
			animated_sprite_2d.speed_scale = 1
		if yDir > 0:
			velocity.y = -physics["vineUp"]
		else: if yDir < 0:
			velocity.y = physics["vineDown"]
		else:
			velocity.y = 0
		if Input.is_action_just_pressed("right") and inputAffects:
			if GlobalVariables.marioVineLeft:
				GlobalVariables.marioVineLeft = false
				position.x += 16
				animated_sprite_2d.flip_h = true
			else:
				GlobalVariables.marioVine = false
				position.x += 4
		if Input.is_action_just_pressed("left") and inputAffects:
			if not GlobalVariables.marioVineLeft:
				GlobalVariables.marioVineLeft = true
				position.x -= 16
				animated_sprite_2d.flip_h = false
			else:
				GlobalVariables.marioVine = false
				position.x -= 4

	if velocity.x > maxSpeed:
		velocity.x = maxSpeed
	if velocity.x < -maxSpeed:
		velocity.x = -maxSpeed
	
	if goal_walk:
		maxSpeed = physics["maxWalk"]
		direction = 1.0
		animated_sprite_2d.flip_h = false
		if velocity.x > maxSpeed:
			velocity.x = maxSpeed
		if velocity.x < -maxSpeed:
			velocity.x = -maxSpeed
		velocity.x += direction * accel * delta
		if is_on_wall():
			hide()
	
	
	
	
	
	if GlobalVariables.marioPower == 2:
		if Input.is_action_just_pressed("run"):
			_projectile(load("res://scenes/entities/projectiles/fireball.tscn"),200,0)
	if GlobalVariables.marioPower == 3:
		if Input.is_action_just_pressed("run"):
			_projectile(load("res://scenes/entities/projectiles/iceball.tscn"),100,0)
	
	
	if throwFrames:
		throwFrames -= 1
		animated_sprite_2d.animation = "throwBig"
	
	# flagpole animation
	if slidingOnPole:
		
		animated_sprite_2d.animation = "climb" + GlobalVariables.marioVisual
		velocity.y = 120
		velocity.x = 0
		if not is_on_floor():
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.speed_scale = 1
		position.x = floor(position.x/16)*16
		if is_on_floor() and timer.time_left == 0:
			timer.start()
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.speed_scale = 0
			position.x += 16
	
	
	
	
	move_and_slide()
	
	
	

func _on_goal_pole() -> void:
	inputAffects = false
	slidingOnPole = true



func _on_timer_timeout() -> void:
	if slidingOnPole:
		slidingOnPole = false
		goal_walk = true
	if GlobalVariables.marioState == -3:
		velocity.x = 0
		velocity.y = -300
		GlobalVariables.marioState = -4
	if isPipe:
		_changeRoom()
	if GlobalVariables.marioState == -5:
		GlobalVariables.marioState = 0
		GlobalVariables.paused = false


func hurt() -> void:
	if GlobalVariables.marioInvuln > 0:
		return
	GlobalVariables.paused = true
	if GlobalVariables.marioPower == 0:
		GlobalVariables.marioState = -3
	else:
		GlobalVariables.marioState = -2
		GlobalVariables.marioPower = 0
		GlobalVariables.marioInvuln = 360
		hurt_pipe.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if GlobalVariables.marioState == -1 or GlobalVariables.marioState == -2:
		if animated_sprite_2d.animation == "grow" or animated_sprite_2d.animation == "shrink":
			GlobalVariables.marioSize = 1 - GlobalVariables.marioSize
			GlobalVariables.marioState = 0
			GlobalVariables.paused = false
	if animated_sprite_2d.animation == "swim" + GlobalVariables.marioVisual:
		animated_sprite_2d.animation = "swimIdle" + GlobalVariables.marioVisual


func _on_coinsound() -> void:
	coin_sfx.play()

func _physics_update():
	if GlobalVariables.marioVine:
		return
	
	# grounded stuff
	if is_on_floor():
		accel = physics["walkAccel"]
		decel = physics["walkDecel"]
		if Input.is_action_pressed("run"):
			maxSpeed = physics["maxRun"]
		else:
			maxSpeed = physics["maxWalk"]
		
		if abs(velocity.x) > 1:
			jumpSpeed = physics["jump"]
	
	
	
	var jumping = conditionReturn(Input.is_action_pressed("jump"),"Jump","")
	var currState = conditionReturn(abs(velocity.x) < 60.0,"Stand",conditionReturn(abs(velocity.x) < 138.75,"Walk","Run"))
	
	if Input.is_action_just_pressed("jump") or Input.is_action_just_released("jump"):
		gravity = physics["grav" + currState + jumping]
	
	if velocity.y >= -1 and not is_on_floor():
		gravity = physics["grav" + currState]
	
	
	jumpSpeed = physics[conditionReturn(abs(velocity.x) > 138.75,"run","") + "jump"]
	
	if not is_on_floor():
		if velocity.x * direction == abs(velocity.x):
			if abs(velocity.x) >= 93.75:
				accel = physics["airAccel2"]
			else:
				accel = physics["airAccel1"]
		else:
			if abs(velocity.x) >= 93.75:
				accel = physics["airDecel1"]
			if abs(velocity.x) < 93.75:
				if jumpStartSpeed < 108.75:
					accel = physics["airDecel2"]
				else:
					accel = physics["airDecel3"]
	
	if velocity.x * direction < 0 and is_on_floor():
		accel = physics["skidDecel"]
	
	if GlobalVariables.intermission:
		maxSpeed = physics["maxInter"]
		gravity = physics["gravInter"]
	
	if GlobalVariables.underwater:
		if position.y > 40:
			jumpSpeed = physics["swim"]
			if Input.is_action_pressed("jump"):
				gravity = physics["swimGravJump"]
			else:
				gravity = physics["swimGrav"]
		else:
			jumpSpeed = 0
			gravity = physics["swimGravSurf"]

func conditionReturn(condition:bool,trueValue,falseValue):
	if condition:
		return trueValue
	else:
		return falseValue

func _changeRoom():
	var checkType = GlobalVariables.pipes.get(GlobalVariables.marioScreen)
	if checkType is int or checkType is float:
		GlobalVariables.sub = checkType
	if checkType is Array:
		GlobalVariables.world = checkType[GlobalVariables.marioTileX/4]
		if GlobalVariables.levelpack == "SMB":
			if !GlobalVariables.warpShown:
				if GlobalVariables.world == 4 or GlobalVariables.world == 2:
					GlobalVariables.world = 36
				if GlobalVariables.world == 3:
					GlobalVariables.world = 5
		GlobalVariables.level = 1
		GlobalVariables.sub = 0
		GlobalVariables.marioScreen = 0
		get_tree().change_scene_to_file("res://scenes/loading1.tscn")
		return
	GlobalVariables.marioScreen = 0
	get_tree().change_scene_to_file("res://scenes/level.tscn")

func _projectile(projectile:PackedScene,speedX:float,speedY:float):
	var popItem = projectile.instantiate()
	popItem.position = position
	popItem.position.y -= 8
	if animated_sprite_2d.flip_h:
		popItem.velocity.x = -speedX
	else:
		popItem.velocity.x = speedX
	popItem.velocity.y = speedY
	GlobalVariables.add_child(popItem)
	throwFrames = 10
