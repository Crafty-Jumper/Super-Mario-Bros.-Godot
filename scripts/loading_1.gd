extends Node2D

@onready var timer: Timer = $Timer
@onready var lives_label: RichTextLabel = $LivesLabel
@onready var world_label: RichTextLabel = $WorldLabel
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	Music.loadtrack("None",false)
	sprite_2d.texture = Files.load_image("characters/" + GlobalVariables.character + "/animations1.png")
	sprite_2d.material.set_shader_parameter("palette",Files.load_image("characters/" + GlobalVariables.character + "/playerpalette.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	GlobalVariables.generatorActive = false
	
	GlobalVariables.sub = 0
	if GlobalVariables.marioState < 0:
		GlobalVariables.marioState = 0
	GlobalVariables.paused = false
	lives_label.text = "*  " + str(GlobalVariables.marioLives)
	if GlobalVariables.world == 36:
		world_label.text = "WORLD  -" + str(GlobalVariables.level)
	else:
		world_label.text = "WORLD " + str(GlobalVariables.world) + "-" + str(GlobalVariables.level)
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")
