extends CharacterBody2D

var throwingSpiny : bool = true
var spinyTimer = 200
var fast : bool = false
@onready var lakitu: Sprite2D = $Lakitu
var spiny : PackedScene = load("res://scenes/entities/spiny-egg.tscn")
var leaving : bool = false
var flipped : bool = false

func _ready() -> void:
	GlobalVariables.lakituActive = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if flipped:
		velocity.y += 10 * 60 * delta
		move_and_slide()
		if position.y > get_camera().position.y + 160:
			queue_free()
		return
	
	if GlobalVariables.paused:
		return
	if leaving:
		move_and_slide()
		velocity.x = -50
		return
	
	if !GlobalVariables.lakituActive:
		leaving = true
		return
	
	if throwingSpiny:
		lakitu.frame = 1
	else:
		lakitu.frame = 0
	
	spinyTimer -= 60*delta
	if spinyTimer <= 0:
		if throwingSpiny:
			var spawnedSpiny = spiny.instantiate()
			spawnedSpiny.position = position
			get_parent().add_child(spawnedSpiny)
			spinyTimer = 200
			throwingSpiny = false
		else:
			spinyTimer = 20
			throwingSpiny = true
	
	if abs(position.x - get_camera().position.x) < 64:
		fast = false
	else:
		if position.x - get_camera().position.x < 0:
			lakitu.flip_h = false
		else:
			lakitu.flip_h = true
	if abs(position.x - get_camera().position.x) > 112:
		fast = true
	
	if lakitu.flip_h:
		if fast:
			velocity.x = -256
		else:
			velocity.x = -50
	else:
		if fast:
			velocity.x = 256
		else:
			velocity.x = 50
	
	
	move_and_slide()

func get_camera() -> Camera2D:
	return get_tree().get_root().get_camera_2d()

func flip():
	velocity.y = -50
	velocity.x = 0
	lakitu.flip_v = true
	lakitu.frame = 1
	flipped = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if flipped:
		return
	
	if body.is_in_group("player"):
		if GlobalVariables.marioInvinc > 0:
			flip()
		if body.velocity.y > 0 or body.position.y < position.y - 9:
			body.velocity.y = -300
			flip()
			body.swim_sfx.play()
		else:
			body.hurt()
	if body.is_in_group("fireball"):
		flip()
		body.explode()
