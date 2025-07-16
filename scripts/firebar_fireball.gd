extends Sprite2D

@onready var area_detection: Area2D = $AreaDetection
var direction = 0
func _process(delta: float) -> void:
	
	rotation = floor(direction*(2/PI))/(2/PI)
	
	direction += 15 * delta
	
	





func _on_area_detection_body_entered(body: Node2D) -> void:
	if GlobalVariables.marioInvuln or GlobalVariables.marioInvinc:
		return
	if body.name == "Mario":
		GlobalVariables.paused = true
		if GlobalVariables.marioState > 0:
			GlobalVariables.marioState = -2
			body.hurt_pipe.play()
			GlobalVariables.marioInvuln = 6 * 60
		else:
			GlobalVariables.marioState = -3
			GlobalVariables.marioLives -= 1
