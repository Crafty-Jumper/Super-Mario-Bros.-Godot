extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var goal_music: AudioStreamPlayer = $GoalMusic
@onready var mario: CharacterBody2D = $Mario
@onready var area_2d: CharacterBody2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var pause_menu: Control = $CanvasLayer2/PauseMenu
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var pause: AudioStreamPlayer = $AudioStreamPlayer



@export var song : int = GlobalVariables.song
@export var underwater : bool = false

var canStartGoalMusic : bool = true
const songNames = ["None","Overworld","Underground","Underwater","Castle","Star"]
var overrideBgmVolume : bool = false


func _ready() -> void:
	mario.position = Vector2(GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioX"],GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioY"])
	if GlobalVariables.sub == GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["pipes"][GlobalVariables.marioScreen]:
		mario.position.x += GlobalVariables.marioOffset * 256
	GlobalVariables.fixpath()
	camera_2d.limit_bottom = GlobalVariables.levelHeight * 16
	camera_2d.limit_right = GlobalVariables.levelWidth * 16
	GlobalVariables.pauseMenuOpen = false
	
	song = GlobalVariables.song
	if song > -1:
		Music.loadtrack(songNames[song],true)
	else:
		Music.loadtrack("custom" + str(abs(song)),true)
	
	
	
func _process(delta: float) -> void:
	
	
	if GlobalVariables.pauseMenuOpen:
		_pause_process(true)
		pause_menu.show()
		if not overrideBgmVolume:
			Music.musicVolume([-80,-80,0,0,0])
	else:
		pause_menu.hide()
		_pause_process(false)
		if not overrideBgmVolume:
			Music.musicVolume([0,0,0,0,0])
	
	
	color_rect.color = Color(GlobalVariables.levelBGColor)
	if mario.goal_walk and canStartGoalMusic:
		goal_music.play()
		canStartGoalMusic = false
		
		
	static_body_2d.position.y = mario.position.y
	
	if GlobalVariables.marioState == -3:
		Music.loadtrack("None",false)
	
	
	
	if GlobalVariables.marioInvinc > 60:
		if not song == 5:
			Music.loadtrack("Star",true)
	else:
		if song > -1:
			Music.loadtrack(songNames[song],true)
		else:
			Music.loadtrack("custom" + str(abs(song)),true)
	
	if GlobalVariables.marioInvinc < 60:
		pass
	
	if mario.position.x > camera_2d.position.x - 8:
		if mario.velocity.x > 0:
			camera_2d.position.x += mario.velocity.x * delta
	if GlobalVariables.paused:
		return
	if mario.position.x >= camera_2d.position.x - 48 and mario.position.x < camera_2d.position.x - 9:
		if mario.velocity.x > 0:
			camera_2d.position.x += mario.velocity.x * delta * 0.75
	
	
	
	
	if Input.is_action_just_pressed("pause"):
		pause.play()
	



func _on_mario_goal_pole() -> void:
	overrideBgmVolume = true
	Music.musicVolume([-80,-80,-80,-80,-80])

func _on_goal_music_finished() -> void:
	GlobalVariables.level += 1
	GlobalVariables.sub = 0
	GlobalVariables.marioScreen = 0
	get_tree().change_scene_to_file("res://scenes/loading1.tscn")
	
	
func _pause_process(startPause: bool) -> void:
	if startPause:
		mario.process_mode = Node.PROCESS_MODE_DISABLED
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		static_body_2d.process_mode = Node.PROCESS_MODE_DISABLED
		tile_map_layer_2.process_mode = Node.PROCESS_MODE_DISABLED
		goal_music.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		mario.process_mode = Node.PROCESS_MODE_ALWAYS
		area_2d.process_mode = Node.PROCESS_MODE_ALWAYS
		static_body_2d.process_mode = Node.PROCESS_MODE_ALWAYS
		tile_map_layer_2.process_mode = Node.PROCESS_MODE_ALWAYS
		goal_music.process_mode = Node.PROCESS_MODE_ALWAYS
