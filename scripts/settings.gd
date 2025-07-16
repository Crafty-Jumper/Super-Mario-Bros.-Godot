extends Node2D

@onready var arrow: Sprite2D = $Arrow
@onready var options_label: RichTextLabel = $OptionsLabel
var selectedButtonLeft = 0
var selectedButtonRight = 0
var isRight : bool = false
var options = [
	["SMB","NEW LEVELS","","","",""],
	["5","4","3","2","1","0"],
	["MARIO","LUIGI","WARIO","THE MEME LORD","",""],
	["","","","","",""],
	["","","","","",""],
	["","","","","",""]
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("jump"):
		if selectedButtonLeft == 5:
			get_tree().change_scene_to_file("res://scenes/title screen.tscn")
		if isRight:
			isRight = false
		else:
			isRight = true
	
	if isRight:
		arrow.position.y = 28 + 32 * selectedButtonRight
		arrow.position.x = 140
	else:
		arrow.position.y = 28 + 32 * selectedButtonLeft
		arrow.position.x = 21
	
	if Input.is_action_just_pressed("down"):
		if not isRight:
			if selectedButtonLeft < 2:
				selectedButtonLeft += 1
			else:
				selectedButtonLeft = 5
		else:
			selectedButtonRight += 1
		
	if Input.is_action_just_pressed("up"):
		if selectedButtonLeft == 5:
			selectedButtonLeft = 2
		else:
			if not isRight:
				if selectedButtonLeft > 0:
					selectedButtonLeft -= 1
			else:
				selectedButtonRight -= 1
	
	selectedButtonRight = clamp(selectedButtonRight,0,5)
	
	options_label.text = options[selectedButtonLeft][0] + "\n\n\n\n" + options[selectedButtonLeft][1] + "\n\n\n\n" + options[selectedButtonLeft][2] + "\n\n\n\n" + options[selectedButtonLeft][3] + "\n\n\n\n" + options[selectedButtonLeft][4] + "\n\n\n\n" + options[selectedButtonLeft][5]
	
	
