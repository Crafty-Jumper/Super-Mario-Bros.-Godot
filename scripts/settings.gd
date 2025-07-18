extends Node2D

@onready var arrow: Sprite2D = $Arrow
@onready var options_label: RichTextLabel = $OptionsLabel
@onready var option_selector: Label = $OptionSelector
@onready var option_selector_2: Label = $OptionSelector2
@onready var option_selector_3: Label = $OptionSelector3
@onready var option_selector_4: Label = $OptionSelector4
@onready var option_selector_5: Label = $OptionSelector5
@onready var option_selector_6: Label = $OptionSelector6






var selectedButtonLeft = 0
var selectedButtonRight = 0
var isRight : bool = false
var option = [
	["LEVEL PACK","","","","",""],
	["MASTER","PUL1","PUL2","TRI","NOI","DPCM"],
	["CHARACTER","","","","",""],
	["","","","","",""],
	["","","","","",""],
	["","","","","",""]
]
var options = [
	[["SMB","NEW LEVELS"],[""],[""],[""],[""],[""]],
	[[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9,10],[0,1,2,3,4,5,6,7,8,9,10]],
	[["MARIO","LUIGI","TOAD","WARIO","WALUIGI"],[],[],[],[],[]],
	[[],[],[],[],[],[]],
	[[],[],[],[],[],[]],
	[[],[],[],[],[],[]]
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
	
	option_selector.focused = false
	option_selector_2.focused = false
	option_selector_3.focused = false
	option_selector_4.focused = false
	option_selector_5.focused = false
	option_selector_6.focused = false
	
	option_selector.options = options[selectedButtonLeft][0]
	option_selector_2.options = options[selectedButtonLeft][1]
	option_selector_3.options = options[selectedButtonLeft][2]
	option_selector_4.options = options[selectedButtonLeft][3]
	option_selector_5.options = options[selectedButtonLeft][4]
	option_selector_6.options = options[selectedButtonLeft][5]
	
	if isRight:
		if selectedButtonRight == 0:
			option_selector.focused = true
		if selectedButtonRight == 1:
			option_selector_2.focused = true
		if selectedButtonRight == 2:
			option_selector_3.focused = true
		if selectedButtonRight == 3:
			option_selector_4.focused = true
		if selectedButtonRight == 4:
			option_selector_5.focused = true
		if selectedButtonRight == 5:
			option_selector_6.focused = true
			
			
	if isRight:
		arrow.hide()
	else:
		arrow.position.y = 28 + 32 * selectedButtonLeft
		arrow.position.x = 21
		arrow.show()
	
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
	options_label.text = option[selectedButtonLeft][0] + "\n\n\n\n" + option[selectedButtonLeft][1] + "\n\n\n\n" + option[selectedButtonLeft][2] + "\n\n\n\n" + option[selectedButtonLeft][3] + "\n\n\n\n" + option[selectedButtonLeft][4] + "\n\n\n\n" + option[selectedButtonLeft][5]
	
	
	
