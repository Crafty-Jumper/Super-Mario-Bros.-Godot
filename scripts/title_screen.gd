extends Node2D

@onready var mushroom_select: Sprite2D = $"Mushroom-select"
@onready var mario: AnimatedSprite2D = $Mario
@onready var title: Sprite2D = $Title
@onready var color_rect: ColorRect = $ColorRect
@onready var color_rect_2: ColorRect = $ColorRect2
@onready var canvas_layer: CanvasLayer = $CanvasLayer
var selectedButton = 0
var fadeColor = 0
var fading : bool = false
var targetString : String = ""

func _ready() -> void:
	Music.loadtrack("None",false)


func _process(delta: float) -> void:
	mushroom_select.position.y = 132 + selectedButton * 16
	mario.position = Vector2(GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioX"],GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioY"])
	title.material.set_shader_parameter("accessRow",GlobalVariables.theme+1)
	color_rect.color = Color(GlobalVariables.levelBGColor)
	
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
