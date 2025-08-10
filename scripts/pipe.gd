extends StaticBody2D

@export_enum ("up","down","left","right") var direction = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",true)
		body.set_meta("pipeDirection",direction)
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",false)
