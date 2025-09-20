extends CharacterBody2D

@onready var cheepcheep: Sprite2D = $Cheepcheep
var flipped : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity.y = -350
	velocity.x = randf_range(-150,150)
	if velocity.x < 10 and velocity.x > -10:
		velocity.x = randf_range(-200.0,200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += 5*60*delta
	
	if velocity.x < 0:
		cheepcheep.flip_h = true
	
	move_and_slide()
	
	if position.y > GlobalVariables.levelHeight * 16 + 8:
		queue_free()


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
	cheepcheep.flip_v = true
	cheepcheep.frame = 1
	flipped = true
