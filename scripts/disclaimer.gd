extends Node2D

var frameCount = 0
@onready var disclaimer: RichTextLabel = $Disclaimer
@onready var color_rect_2: ColorRect = $ColorRect2
var fading : bool = false
@onready var bump: AudioStreamPlayer = $Bump
@onready var coin: AudioStreamPlayer = $Coin
@onready var life: AudioStreamPlayer = $Life

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Save.firstLoad:
		get_tree().change_scene_to_file("res://scenes/title screen.tscn")
	if fading:
		color_rect_2.color.a += 0.025
		if color_rect_2.color.a >= 2:
			get_tree().change_scene_to_file("res://scenes/title screen.tscn")
	
	
	frameCount += 1
	
	if frameCount == 40:
		bump.play()
		disclaimer.visible_characters = 107
	if frameCount == 120:
		bump.play()
		disclaimer.visible_characters = 185
	if frameCount == 200:
		bump.play()
		disclaimer.visible_characters = 272
	if frameCount == 320:
		coin.play()
	if frameCount > 320:
		disclaimer.visible_characters = 310
		if Input.is_key_pressed(KEY_SPACE):
			if !fading:
				life.play()
			fading = true
