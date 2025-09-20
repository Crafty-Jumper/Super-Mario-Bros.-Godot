extends StaticBody2D

@export_enum ("up","right","down","left") var direction = 0
@onready var rich_text_label: RichTextLabel = $RichTextLabel

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",true)
		body.set_meta("pipeDirection",direction)

func _process(_delta: float) -> void:
	var checkType = GlobalVariables.pipes.get(position.x/256)
	if GlobalVariables.warpShown:
		if checkType is Array:
			rich_text_label.text = ""
			if checkType.get(fmod(position.x,256)/16/4) is float or checkType.get(fmod(position.x,256)/16/4) is int:
				rich_text_label.text = str(int(checkType.get(fmod(position.x,256)/16/4)))
				if rich_text_label.text == "36":
					rich_text_label.text = ""
			rich_text_label.show()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Mario":
		body.set_meta("canPipe",false)
