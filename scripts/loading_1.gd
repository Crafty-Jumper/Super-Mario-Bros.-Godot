extends Node2D

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var timer: Timer = $Timer
@onready var lives_label: RichTextLabel = $LivesLabel
@onready var world_label: RichTextLabel = $WorldLabel


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	GlobalVariables.sub = 0
	if GlobalVariables.marioState < 0:
		GlobalVariables.marioState = 0
	GlobalVariables.paused = false
	lives_label.text = "* " + str(GlobalVariables.marioLives)
	world_label.text = "WORLD " + str(GlobalVariables.world) + "-" + str(GlobalVariables.level)
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
