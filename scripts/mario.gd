extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var big_jump: AudioStreamPlayer2D = $BigJump
@onready var timer: Timer = $Timer
@onready var small_jump: AudioStreamPlayer2D = $SmallJump
@onready var ColDown: CollisionShape2D = $ColDown
@onready var ColUp: CollisionShape2D = $ColUp
@onready var dead_music: AudioStreamPlayer2D = $DeadMusic
@onready var powerup: AudioStreamPlayer2D = $Powerup
@onready var hurt_pipe: AudioStreamPlayer2D = $"Hurt&Pipe"
@onready var coin_sfx: AudioStreamPlayer2D = $CoinSFX
@onready var swim_sfx: AudioStreamPlayer2D = $SwimSFX

signal goal_pole

var goal_walk : bool = false
var slidingOnPole : bool = false


const walkSpeed = 93.75
const walkAccel = 133.59375
const minWalkSpeed = 4.453125
const runAccel = 200.390625


const maxFall = 240
const gravityDie = 750


const walkDecel = 182.8125
const runSpeed = 153.75
const turnDecel = 365.625
const waterSpeed = 63.75
var jumpStartSpeed = 0

# the pain of jumping values
const gravityJumpStand = 450
const gravityJumpWalk = 421.875
const gravityJumpRun = 562.5
const gravityStand = 1575
const gravityWalk = 1350
const gravityRun = 2025
const jump = -240
const jumpRun = -300

# the pain of swimming values
const gravitySwimNorm = 140.625
const gravitySwimDrain = 126.5625
const gravitySwimSurf = 337.5
const gravitySwimJumpNorm = 3.0469 * 60
const gravitySwimJumpDrain = 0.9375 * 60

const swim = -90
const swimDrain = -60

var maxMoveSpeed = walkSpeed
var accel = walkAccel

var inputAffects : bool = true
var debug : bool = false
var canPipe : bool = false
var isPipe : bool = false
var fireball : PackedScene = load("res://scenes/entities/fireball.tscn")
var isDrain : bool = false

func _physics_process(delta: float) -> void:
	canPipe = get_meta("canPipe")
	GlobalVariables.marioScreen = floor(position.x/256)
	
	
	
	if GlobalVariables.marioInvinc == 0:
		if GlobalVariables.marioState == 2:
			animated_sprite_2d.material.set_shader_parameter("accessRow",2)
		else:
			animated_sprite_2d.material.set_shader_parameter("accessRow",1)
	
	
	if canPipe:
		if is_on_floor() and get_meta("pipeDirection") < 3:
			if Input.is_action_pressed("down") and get_meta("pipeDirection") == 0:
				isPipe = true
				hurt_pipe.play()
			if Input.is_action_pressed("right") and get_meta("pipeDirection") == 1:
				isPipe = true
				hurt_pipe.play()
			if Input.is_action_pressed("left") and get_meta("pipeDirection") == 2:
				isPipe = true
				hurt_pipe.play()
	if isPipe:
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
	
	var direction := Input.get_axis("left", "right") * float(inputAffects)
	
	if fmod(floor(GlobalVariables.marioInvuln),2) == 1:
		hide()
	else:
		show()
	
	if Input.is_action_just_pressed("ui_down"):
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
		animated_sprite_2d.animation = "grow"
		animated_sprite_2d.speed_scale = 1
		return
	
	if GlobalVariables.marioState == -2:
		animated_sprite_2d.animation = "shrink"
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
		if position.y > 3000:
			if GlobalVariables.marioLives > 0:
				get_tree().change_scene_to_file("res://scenes/loading1.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/loading2.tscn")
		
		return
	
	if GlobalVariables.marioState == -5:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/8))
		if timer.is_stopped():
			timer.start(1)
		return
	
	if GlobalVariables.marioInvinc > 60:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/2))
	if GlobalVariables.marioInvinc < 60 and GlobalVariables.marioInvinc > 0:
		animated_sprite_2d.material.set_shader_parameter("accessRow",fmod(animated_sprite_2d.material.get_shader_parameter("accessRow")+1,7)+(1/64))
	
	
	
	if GlobalVariables.marioState == 0:
		ColUp.disabled = true
	else:
		ColUp.disabled = false
	
	
	
	if not slidingOnPole:
		animated_sprite_2d.speed_scale = abs(velocity.x/walkSpeed)
		if animated_sprite_2d.speed_scale < 0.5:
			animated_sprite_2d.speed_scale = 0.5
		if get_parent().underwater:
			animated_sprite_2d.speed_scale = 1
		if is_on_floor():
			if not velocity.x == 0 or direction:
				animated_sprite_2d.animation = "walk" + GlobalVariables.marioVisual
			else:
				animated_sprite_2d.animation = "idle" + GlobalVariables.marioVisual
			if velocity.x * direction < 0:
				animated_sprite_2d.animation = "turn" + GlobalVariables.marioVisual
		else:
			if get_parent().underwater:
				if not animated_sprite_2d.animation == "swim" + GlobalVariables.marioVisual:
					animated_sprite_2d.animation = "swimIdle" + GlobalVariables.marioVisual
			else:
				animated_sprite_2d.animation = "jump" + GlobalVariables.marioVisual
		
		
		if not animated_sprite_2d.is_playing():
			animated_sprite_2d.play()
	# Add the gravity.
	if not is_on_floor():
		if not get_parent().underwater:
			if Input.is_action_pressed("jump") and velocity.y < 0:
				if abs(velocity.x) < 60:
					velocity.y += gravityJumpStand * delta
				else: if abs(velocity.x) < 138.75:
					velocity.y += gravityJumpWalk * delta
				else:
					velocity.y += gravityJumpRun * delta
			else:
				if abs(velocity.x) < 60:
					velocity.y += gravityStand * delta
				else: if abs(velocity.x) < 138.75:
					velocity.y += gravityWalk * delta
				else:
					velocity.y += gravityRun * delta
			if velocity.y > maxFall:
				velocity.y = maxFall
		else:
			# water physics amirite
			if Input.is_action_pressed("jump"):
				if position.y > 40:
					if isDrain:
						velocity.y += (gravitySwimJumpDrain * delta) + (3.75)
					else:
						velocity.y += gravitySwimJumpNorm * delta
				else:
					velocity.y += gravitySwimSurf * delta
			else:
				if position.y > 40:
					if isDrain:
						velocity.y += (gravitySwimDrain * delta) + (3.75)
					else:
						velocity.y += gravitySwimNorm * delta
				else:
					velocity.y += gravitySwimSurf * delta
			if isDrain:
				if velocity.y > -swim:
					velocity.y = -swim
			
			
			
	
		
	# jumping
	if not get_parent().underwater:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if inputAffects:
				if abs(velocity.x) < 138.75:
					velocity.y = jump
				else:
					velocity.y = jumpRun
				if GlobalVariables.marioState == 0:
					small_jump.playing = true
				else:
					big_jump.playing = true
	else:
		if Input.is_action_just_pressed("jump"):
			if inputAffects:
				swim_sfx.play()
				animated_sprite_2d.animation = "swim" + GlobalVariables.marioVisual
				animated_sprite_2d.frame = 0
				if position.y > 40:
					if isDrain:
						velocity.y = swimDrain
					else:
						velocity.y = swim
		
		
		
		
		
	# movement
	if not get_parent().underwater:
		if direction < 0 and is_on_floor():
			animated_sprite_2d.flip_h = true
		if direction > 0 and is_on_floor():
			animated_sprite_2d.flip_h = false
	else:
		if direction < 0:
			animated_sprite_2d.flip_h = true
		if direction > 0:
			animated_sprite_2d.flip_h = false
	
	if inputAffects:
		if is_on_floor():
			jumpStartSpeed = abs(velocity.x)
			if direction:
				if velocity.x * direction > 0:
					velocity.x += direction * accel * delta
				else:
					velocity.x += direction * turnDecel * delta
			else:
				velocity.x = move_toward(velocity.x, 0, walkDecel * delta)
			
			
			if not get_parent().underwater:
				if Input.is_action_pressed("run"):
					maxMoveSpeed = runSpeed
					accel = runAccel
				else:
					maxMoveSpeed = walkSpeed
					accel = walkAccel
			else:
				maxMoveSpeed = waterSpeed
				accel = runAccel
				
		else:
			if direction == velocity.x/abs(velocity.x):
				if velocity.x < walkSpeed:
					accel = walkAccel
				else:
					accel = runAccel
			else:
				if velocity.x >= walkSpeed:
					accel = runAccel
				else:
					if jumpStartSpeed < 108.75:
						accel = walkAccel
					else:
						accel = 3.046875
			if get_parent().underwater:
				maxMoveSpeed = walkSpeed
			
			if direction:
				velocity.x += direction * accel * delta
				
			
			
			
		if velocity.x > maxMoveSpeed:
			velocity.x = maxMoveSpeed
		if velocity.x < -maxMoveSpeed:
			velocity.x = -maxMoveSpeed
	
	if goal_walk:
		direction = 1.0
		animated_sprite_2d.flip_h = false
		accel = walkAccel
		maxMoveSpeed = walkSpeed
		if velocity.x > maxMoveSpeed:
			velocity.x = maxMoveSpeed
		if velocity.x < -maxMoveSpeed:
			velocity.x = -maxMoveSpeed
		velocity.x += direction * accel * delta
		if is_on_wall():
			hide()
	
	
	
	
	
	if GlobalVariables.marioState == 2:
		if Input.is_action_just_pressed("run"):
			var popItem = fireball.instantiate()
			popItem.position = position
			popItem.position.y -= 8
			if animated_sprite_2d.flip_h:
				popItem.velocity.x = -200
			else:
				popItem.velocity.x = 200
			get_parent().add_child(popItem)
			animated_sprite_2d.animation = "throw" + GlobalVariables.marioVisual
	
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
		GlobalVariables.sub = GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["pipes"][GlobalVariables.marioScreen]
		GlobalVariables.marioScreen = 0
		GlobalVariables.fixpath()
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if GlobalVariables.marioState == -5:
		GlobalVariables.marioState = 2
		GlobalVariables.paused = false


func hurt() -> void:
	if GlobalVariables.marioInvuln > 0:
		return
	GlobalVariables.paused = true
	if GlobalVariables.marioState == 0:
		GlobalVariables.marioState = -3
	else:
		GlobalVariables.marioState = -2
		GlobalVariables.marioInvuln = 360
		hurt_pipe.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if GlobalVariables.marioState == -1:
		if animated_sprite_2d.animation == "grow":
			GlobalVariables.marioState = 1
			GlobalVariables.paused = false
	if GlobalVariables.marioState == -2:
		if animated_sprite_2d.animation == "shrink":
			GlobalVariables.marioState = 0
			GlobalVariables.paused = false
	if animated_sprite_2d.animation == "swim" + GlobalVariables.marioVisual:
		animated_sprite_2d.animation = "swimIdle" + GlobalVariables.marioVisual


func _on_coinsound() -> void:
	coin_sfx.play()
