extends Node2D

@onready var timer: Timer = $Timer
@onready var lives_label: RichTextLabel = $LivesLabel
@onready var world_label: RichTextLabel = $WorldLabel


func _ready() -> void:
	Music.loadtrack("None",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	GlobalVariables.sub = 0
	if GlobalVariables.marioState < 0:
		GlobalVariables.marioState = 0
	GlobalVariables.paused = false
	lives_label.text = "* " + str(GlobalVariables.marioLives)
	if GlobalVariables.world == 36:
		world_label.text = "WORLD  -" + str(GlobalVariables.level)
	else:
		world_label.text = "WORLD " + str(GlobalVariables.world) + "-" + str(GlobalVariables.level)
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
