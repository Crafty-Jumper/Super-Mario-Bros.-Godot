extends CharacterBody2D

var jumpFrames = 0
@onready var sprite_2d: Sprite2D = $Sprite2D
var active : bool = false
var flipped : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if GlobalVariables.paused:
		return
	if flipped:
		velocity.y += 1
		move_and_slide()
		$CollisionShape2D.disabled = true
		return
	
	if not active:
		return
	
	jumpFrames -= 1
	if jumpFrames < 0:
		velocity.y = 20
		velocity.x = 0
		sprite_2d.frame = 1
	else:
		velocity.y -= 10
		sprite_2d.frame = 0
		if GlobalVariables.marioTileX * 16 < fmod(position.x,256):
			velocity.x = velocity.y
		else:
			velocity.x = -velocity.y
	
	if (GlobalVariables.marioTileY - 2) * 16 < position.y:
		if jumpFrames < -30:
			jumpFrames = 20
	move_and_slide()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true


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

func flip() -> void:
	velocity.y = -50
	velocity.x = 0
	sprite_2d.flip_v = true
	sprite_2d.frame = 1
	flipped = true
