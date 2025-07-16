extends StaticBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",true)
		if get_meta("canHit"):
			body.set_meta("pipeDirection",2)
		if get_meta("getsReplaced"):
			body.set_meta("pipeDirection",int(body.get_meta("pipeDirection"))+1)
		


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",false)
