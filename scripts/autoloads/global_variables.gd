extends Node

var marioVisual = "Small"
var marioInvuln = 0
var marioLives = 1000
var marioInvinc = 0
var marioState = 0
var marioSize = 0
var marioPower = 0

var paused : bool = false
var world : int = 1
var level : int = 1
var sub : int = 0
var coin : int = 0
var score : int = 0
var pauseMenuOpen : bool = false
var marioVine : bool = false
var marioVineLeft : bool = true
var marioClimbing : bool = false
var marioScreen : int = 0
var marioOffset = 0
var marioTileX : int = 0
var marioTileY : int = 0

# level related stuff
var theme = 0
var song = 0
var underwater : bool = false
var bonus : bool = false
var intermission : bool = false

var levelpack = "SMB"
var levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
var leveldata = FileAccess.open("res://Level Data/" + levelpack + "/leveldata.json", FileAccess.READ)
var leveldatajson = JSON.parse_string(leveldata.get_as_text())
var levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix
var levelHeight = leveldatajson[levelPrefix]["levelHeight"]
var levelWidth = leveldatajson[levelPrefix]["levelWidth"]
var levelBGColor = leveldatajson[levelPrefix]["bgCol"]

func _ready() -> void:
	fixpath()
	var timer = Timer.new()
	add_child(timer)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if pauseMenuOpen:
			pauseMenuOpen = false
		else:
			pauseMenuOpen = true
	if pauseMenuOpen:
		return
	fixpath()
	if marioSize == 0:
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
	if marioInvinc:
		pass

func map(input_min: float, input_max: float, output_min: float, output_max: float, input: float):
	var output = input - input_min
	output = output/input_max
	output = output*output_max
	output = output+output_min
	return output

func fixpath() -> void:
	GlobalVariables.levelpack = Save.config.get_value("Misc","levelPack","SMB")
	song = leveldatajson[levelPrefix]["song"]
	bonus = leveldatajson[levelPrefix]["bonus"]
	intermission = leveldatajson[levelPrefix]["intermission"]
	levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
	if FileAccess.file_exists("res://Level Data/" + levelpack + "/" + levelPrefix + "_Tiles.csv"):
		levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix
	else:
		levelPath = "user://data/Level Packs/" + levelpack + "/" + levelPrefix
	if FileAccess.file_exists("res://Level Data/" + levelpack + "/leveldata.json"):
		leveldata = FileAccess.open("res://Level Data/" + levelpack + "/leveldata.json", FileAccess.READ)
	else:
		leveldata = FileAccess.open("user://data/Level Packs/" + levelpack + "/leveldata.json", FileAccess.READ)
	theme = leveldatajson[levelPrefix]["levelTheme"]
	levelHeight = leveldatajson[levelPrefix]["levelHeight"]
	levelWidth = leveldatajson[levelPrefix]["levelWidth"]
	levelBGColor = leveldatajson[levelPrefix]["bgCol"]
	if leveldatajson[levelPrefix]["pipescreen"].get(marioScreen) is int:
		marioOffset = leveldatajson[levelPrefix]["pipescreen"][marioScreen]
	else:
		marioOffset = 0
