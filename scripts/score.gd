extends RichTextLabel

@export var score = 0
var distance = 0
const speed = 1

func _ready() -> void:
	GlobalVariables.score += score
	text = str(score)

func _process(delta: float) -> void:
	if distance > speed * 30:
		queue_free()
	position.y -= speed * delta * 60
	distance += speed * delta * 60
