extends Area2D

var time : int = 60
var up : bool = false
var active : bool = false
var distance = 0
var playerNear : bool = false

func _ready() -> void:
	position.y += 24

func _process(_delta: float) -> void:
	if GlobalVariables.paused or GlobalVariables.pauseMenuOpen:
		return
	if not active:
		return
	if fmod(time,120) == 0:
		if up:
			up = false
		else:
			if not playerNear:
				up = true
	time += 1
	
	if GlobalVariables.clearPiranhas:
		queue_free()
	
	
	if up:
		if distance < 48:
			distance += 1
			position.y -= 0.5
	else:
		if distance > 0:
			distance -= 1
			position.y += 0.5

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	active = true





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerNear = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		playerNear = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hurt()
	if body.is_in_group("fireball"):
		queue_free()
		body.queue_free()
