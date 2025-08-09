extends RichTextLabel

@onready var control: Control = $"../Control"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Tile X: " + str(GlobalVariables.marioTileX) + "\n"
	text = text + "Tile Y: " + str(GlobalVariables.marioTileY) + "\n"
	text = text + "Screen: " + str(GlobalVariables.marioScreen) + "\n"
	text = text + "Invincibility: " + str(floor(GlobalVariables.marioInvinc)) + "\n"
	text = text + "Invulnerability: " + str(GlobalVariables.marioInvuln) + "\n"
	
	if visible:
		control.hide()
	else:
		control.show()
	
	if Input.is_action_just_pressed("debugmenu"):
		visible = bool(1-int(visible))
