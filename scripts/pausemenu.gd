extends Control

@onready var texture_rect: TextureRect = $TextureRect
var selectedButton = 0

func _process(_delta: float) -> void:
	texture_rect.position.y = 276.0 + selectedButton * 64
	
	if GlobalVariables.pauseMenuOpen:
		if Input.is_action_just_pressed("down"):
			selectedButton += 1
		if Input.is_action_just_pressed("up"):
			selectedButton -= 1
	else:
		selectedButton = 0
	
	if Input.is_action_just_pressed("jump"):
		if selectedButton == 0:
			GlobalVariables.pauseMenuOpen = false
		if selectedButton == 1:
			GlobalVariables.pauseMenuOpen = false
			GlobalVariables.marioState = -3
			GlobalVariables.paused = true
			GlobalVariables.sub = 0
	
	
