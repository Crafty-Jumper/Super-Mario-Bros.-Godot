extends Label

@export var options = []
@onready var arrow_left: Sprite2D = $ArrowLeft
@onready var arrow_right: Sprite2D = $ArrowRight

var selected = 0
var focused : bool = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if options.size() - 1 < selected:
		selected = 0
	if selected < 0:
		selected = options.size() - 1
	text = str(options.get(selected))
	
	if focused:
		if Input.is_action_just_pressed("left"):
			selected -= 1
		if Input.is_action_just_pressed("right"):
			selected += 1
		arrow_left.show()
		arrow_right.show()
	else:
		arrow_left.hide()
		arrow_right.hide()
	
	
	arrow_left.position.x = -8
	arrow_right.position.x = text.length() * 8
	
