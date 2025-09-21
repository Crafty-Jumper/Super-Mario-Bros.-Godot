extends Node2D

@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var goal_music: AudioStreamPlayer = $GoalMusic
@onready var mario: CharacterBody2D = $Mario
@onready var area_2d: CharacterBody2D = $Area2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var static_body_2d_2: StaticBody2D = $StaticBody2D2
@onready var camera_2d: Camera2D = $Camera2D
@onready var pause_menu: Control = $CanvasLayer2/PauseMenu
@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var tile_map_layer_2: TileMapLayer = $Enemies
@onready var pause: AudioStreamPlayer = $AudioStreamPlayer
@onready var character_body_2d: StaticBody2D = $CharacterBody2D
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var screen_palette: ColorRect = $Camera2D/CanvasLayer/ColorRect
@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var warp_zone_text: RichTextLabel = $WarpZoneText
@onready var enemy_generator: Node2D = $EnemyGenerator

@export var song : int = GlobalVariables.song

var canStartGoalMusic : bool = true
const songNames = ["None","Overworld","Underground","Underwater","Castle","Star","Bonus"]
var overrideBgmVolume : bool = false
var vineExists : bool = true
var prevCamX = 0.0
var prevCamY = 0.0

func _ready() -> void:
	GlobalVariables.generatorActive = false
	parallax_2d.scroll_scale.x = float(get_layer_property(GlobalVariables.levelPath,"Background","parallaxx"))
	
	mario.position = Vector2(GlobalVariables.marioX,GlobalVariables.marioY)
	if GlobalVariables.sub == GlobalVariables.pipes.get(GlobalVariables.marioScreen):
		mario.position.x += GlobalVariables.marioOffset * 256
	if GlobalVariables.enteringVine:
		character_body_2d.position = Vector2(72,GlobalVariables.levelHeight * 16 + 8)
		character_body_2d.origPos = GlobalVariables.levelHeight * 16 + 8
		mario.position = Vector2(64,GlobalVariables.levelHeight * 16 + 16)
		character_body_2d.audio_stream_player.play()
		GlobalVariables.marioClimbing = true
		GlobalVariables.enteringVine = false
	else:
		vineExists = false
		character_body_2d.queue_free()
	
	GlobalVariables.pauseMenuOpen = false
	color_rect.color = Color(GlobalVariables.levelBGColor)
	
	
	
	song = GlobalVariables.song
	if song > -1:
		Music.loadtrack(songNames[song],true)
	else:
		Music.loadtrack("custom" + str(abs(song)),true)
	static_body_2d_2.position.x = GlobalVariables.levelWidth * 16
	
	if GlobalVariables.intermission:
		audio_stream_player_2.play()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reloadlevel"):
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if Input.is_action_just_pressed("worldup"):
		GlobalVariables.world += 1
		GlobalVariables.sub = 0
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if Input.is_action_just_pressed("worlddown"):
		GlobalVariables.world -= 1
		GlobalVariables.sub = 0
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if Input.is_action_just_pressed("levelup"):
		GlobalVariables.level += 1
		GlobalVariables.sub = 0
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	if Input.is_action_just_pressed("leveldown"):
		GlobalVariables.level -= 1
		GlobalVariables.sub = 0
		get_tree().change_scene_to_file("res://scenes/level.tscn")
	
	
	screen_palette.material.set_shader_parameter("accessRow",GlobalVariables.theme)
	
	if vineExists:
		if character_body_2d.position.y <= GlobalVariables.levelHeight * 16 - 78:
			mario.yDir = 1
	
	if camera_2d.position.x >= GlobalVariables.levelWidth * 16 - 128:
		if GlobalVariables.pipes.get(GlobalVariables.levelWidth/16-1) is Array:
			warp_zone_text.position.x = GlobalVariables.levelWidth * 16 - 256
			warp_zone_text.show()
			GlobalVariables.warpShown = true
	
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
	
	
	if Input.is_action_just_pressed("freecam"):
		GlobalVariables.freecam = bool(1-int(GlobalVariables.freecam))
		if GlobalVariables.freecam:
			prevCamX = camera_2d.position.x
			prevCamY = camera_2d.position.y
		else:
			camera_2d.position.x = prevCamX
			camera_2d.position.y = prevCamY
	
	color_rect.color = Color(GlobalVariables.levelBGColor)
	if mario.goal_walk and canStartGoalMusic:
		goal_music.play()
		canStartGoalMusic = false
		
		
	static_body_2d.position.y = mario.position.y
	static_body_2d_2.position.y = mario.position.y
	
	if GlobalVariables.marioState == -3 or GlobalVariables.marioState == -4:
		Music.loadtrack("None",false)
	if mario.position.y > GlobalVariables.levelHeight * 16 + 100 and not GlobalVariables.bonus:
		Music.loadtrack("None",false)
	
	
	if GlobalVariables.marioInvinc > 60:
		Music.loadtrack("Star",true)
	else:
		if song > -1:
			if songNames.get(song) is String:
				Music.loadtrack(songNames.get(song),true)
			else:
				Music.loadtrack("None",true)
		else:
			Music.loadtrack("custom" + str(abs(song)),true)
	
	if GlobalVariables.freecam:
		_pause_process(true)
		camera_2d.position.x += Input.get_axis("left","right") * 10
		camera_2d.position.y += Input.get_axis("up","down") * 10
		camera_2d.limit_left = -1000000
		camera_2d.limit_right = 1000000
		camera_2d.limit_bottom = 1000000
		camera_2d.limit_top = -1000000
	else:
		camera_2d.limit_bottom = GlobalVariables.levelHeight * 16
		camera_2d.limit_right = GlobalVariables.levelWidth * 16
		camera_2d.limit_left = 0
		camera_2d.limit_top = 0
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
		audio_stream_player_2.process_mode = Node.PROCESS_MODE_DISABLED
		enemy_generator.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		mario.process_mode = Node.PROCESS_MODE_ALWAYS
		area_2d.process_mode = Node.PROCESS_MODE_ALWAYS
		static_body_2d.process_mode = Node.PROCESS_MODE_ALWAYS
		tile_map_layer_2.process_mode = Node.PROCESS_MODE_ALWAYS
		goal_music.process_mode = Node.PROCESS_MODE_ALWAYS
		audio_stream_player_2.process_mode = Node.PROCESS_MODE_ALWAYS
		enemy_generator.process_mode = Node.PROCESS_MODE_ALWAYS

func get_layer_property(file:String,layer:String,property:String):
	var tmxfile = XMLParser.new()
	var error = tmxfile.open(file)
	
	if !error == OK:
		return "i got nothin"
	
	
	while tmxfile.read() == OK:
		match tmxfile.get_node_type():
			XMLParser.NODE_ELEMENT:
				if tmxfile.get_node_name() == "layer":
					if tmxfile.get_named_attribute_value("name") == layer:
						var value = tmxfile.get_named_attribute_value(property)
						return value
	return "this shouldn't be seen"
