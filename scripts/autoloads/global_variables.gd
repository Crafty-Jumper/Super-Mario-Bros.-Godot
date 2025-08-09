extends Node

var marioState = 2
var paused : bool = false
var marioVisual = "Small"
var marioInvuln = 0
var marioLives = 1000
var marioInvinc = 0
var world : int = 1
var level : int = 1
var sub : int = 0
var coin : int = 0
var score : int = 0
var pauseMenuOpen : bool = false

# level related stuff
var theme = 0
var song = 0
var levelpack = "SMB"
var levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
var levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"
var marioScreen = 0
var marioOffset = 0

func _ready() -> void:
	fixpath()




func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if pauseMenuOpen:
			pauseMenuOpen = false
		else:
			pauseMenuOpen = true
	
	if pauseMenuOpen:
		return
	
	fixpath()
	
	if marioState == 0:
		marioVisual = "Small"
	else:
		marioVisual = "Big"
		
	if marioInvuln > 0:
		marioInvuln -= 60 * delta
	else:
		marioInvuln = 0
	
	if marioInvinc > 0:
		marioInvinc -= 60 * delta
	else:
		marioInvinc = 0

func fixpath() -> void:
	GlobalVariables.levelpack = Save.config.get_value("Misc","levelPack","SMB")
	levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
	if FileAccess.file_exists("res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"):
		levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"
	else:
		levelPath = "user://data/Level Packs/" + levelpack + "/" + levelPrefix + ".tmx"
