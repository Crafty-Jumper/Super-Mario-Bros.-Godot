extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var overworld_music: AudioStreamPlayer = $OverworldMusic
@onready var goal_music: AudioStreamPlayer = $GoalMusic
@onready var star_music: AudioStreamPlayer = $StarMusic
@onready var mario: CharacterBody2D = $Mario
@onready var area_2d: CharacterBody2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var pause_menu: Control = $CanvasLayer2/PauseMenu
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_2: TileMapLayer = $TileMapLayer2
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export_enum ("Overworld","Underground","Underwater","Castle","Star")
var music = 0
@export var underwater : bool = false

var canStartGoalMusic : bool = true

func _ready() -> void:
	mario.position = Vector2(GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioX"],GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["marioY"])
	if GlobalVariables.sub == GlobalVariables.leveldatajson[GlobalVariables.levelPrefix]["pipes"][GlobalVariables.marioScreen]:
		mario.position.x += GlobalVariables.marioOffset * 256
	GlobalVariables.fixpath()
	camera_2d.limit_bottom = GlobalVariables.levelHeight * 16
	camera_2d.limit_right = GlobalVariables.levelWidth * 16
	GlobalVariables.pauseMenuOpen = false
	
	
func _process(delta: float) -> void:
	if GlobalVariables.pauseMenuOpen:
		overworld_music.stream.set_sync_stream_volume(0,-80)
		overworld_music.stream.set_sync_stream_volume(1,-80)
		_pause_process(true)
		pause_menu.show()
	else:
		overworld_music.stream.set_sync_stream_volume(0,0)
		overworld_music.stream.set_sync_stream_volume(1,0)
		pause_menu.hide()
		_pause_process(false)
	
	
	
	color_rect.color = Color(GlobalVariables.levelBGColor)
	if mario.goal_walk and canStartGoalMusic:
		goal_music.play()
		canStartGoalMusic = false
	
	static_body_2d.position.y = mario.position.y
	
	if GlobalVariables.marioState == -3:
		overworld_music.playing = false
		overworld_music.volume_linear = 0
	
	if GlobalVariables.marioInvinc > 60:
		if not star_music.playing:
			star_music.play()
			overworld_music.stop()
	
	
	if GlobalVariables.marioInvinc < 60:
		if not overworld_music.playing:
			overworld_music.play()
			star_music.stop()
	
	if mario.position.x > camera_2d.position.x - 8:
		if mario.velocity.x > 0:
			camera_2d.position.x += mario.velocity.x * delta
	if GlobalVariables.paused:
		return
	if mario.position.x >= camera_2d.position.x - 48 and mario.position.x < camera_2d.position.x - 9:
		if mario.velocity.x > 0:
			camera_2d.position.x += mario.velocity.x * delta * 0.75
	
	
	
	
	if Input.is_action_just_pressed("pause"):
		audio_stream_player.play()
	



func _on_mario_goal_pole() -> void:
	overworld_music.playing = false
	overworld_music.volume_linear = 0

func _on_goal_music_finished() -> void:
	GlobalVariables.level += 1
	GlobalVariables.sub = 0
	GlobalVariables.marioScreen = 0
	get_tree().change_scene_to_file("res://scenes/loading1.tscn")
	
	
func _pause_process(pause: bool) -> void:
	if pause:
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
