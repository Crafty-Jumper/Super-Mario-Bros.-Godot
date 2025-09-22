extends Node2D

@onready var mushroom_select: Sprite2D = $"Mushroom-select"
@onready var mario: Sprite2D = $Mario
@onready var title: Sprite2D = $Title
@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var pipe_pal: ColorRect = $Camera2D/Pipes/PipePal
@onready var ground_pal: ColorRect = $Camera2D/Ground/GroundPal
@onready var cloud_pal: ColorRect = $Camera2D/Clouds/CloudPal

var selectedButton = 0
var fadeColor = 0
var fading : bool = false
var targetString : String = ""

func _ready() -> void:
	Music.loadtrack("None",false)
	update_screen()

func _process(_delta: float) -> void:
	mario.position = Vector2(GlobalVariables.marioX,GlobalVariables.marioY)
	
	if Input.is_action_just_pressed("down"):
		selectedButton += 1
	if Input.is_action_just_pressed("up"):
		selectedButton -= 1
	
	if fading:
		canvas_layer.hide()
		color_rect_2.color.a += 0.05
		if color_rect_2.color.a >= 2:
			get_tree().change_scene_to_file(targetString)
		
		
	if Input.is_action_just_pressed("jump"):
		if selectedButton == 0:
			get_tree().change_scene_to_file("res://scenes/loading1.tscn")
		if selectedButton == 1:
			fading = true
			targetString = "res://scenes/settings.tscn"

func update_screen():
	mario.texture = Files.load_image("characters/" + GlobalVariables.character + "/animations1.png")
	mario.material.set_shader_parameter("palette",Files.load_image("characters/" + GlobalVariables.character + "/playerPalette.png"))
	mushroom_select.position.y = 132 + selectedButton * 16
	title.material.set_shader_parameter("accessRow",GlobalVariables.theme)
	color_rect.color = Color(GlobalVariables.levelBGColor)
	pipe_pal.material.set_shader_parameter("accessRow",GlobalVariables.pipeTheme)
	ground_pal.material.set_shader_parameter("accessRow",GlobalVariables.theme)
	cloud_pal.material.set_shader_parameter("accessRow",GlobalVariables.cloudTheme)
