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
		body.hurt()
