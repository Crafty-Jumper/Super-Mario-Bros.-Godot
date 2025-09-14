extends Control

@onready var level_label: RichTextLabel = $LevelLabel
@onready var score_label: RichTextLabel = $ScoreLabel
@onready var coin_label: RichTextLabel = $CoinLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GlobalVariables.world == 36:
		level_label.text = " -" + str(GlobalVariables.level)
	else:
		level_label.text = str(GlobalVariables.world) + "-" + str(GlobalVariables.level)
	score_label.text = "0".repeat(6 - str(GlobalVariables.score).length()) + str(GlobalVariables.score)
	coin_label.text = "*" + "0".repeat(2 - str(GlobalVariables.coin).length()) + str(GlobalVariables.coin)
