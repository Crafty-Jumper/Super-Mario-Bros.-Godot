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
var sub : int = 1
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
var marioX = 0
var marioY = 0
var pipes = []
var pipescreen = []

var levelpack = "SMB"
var levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
var levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"
var levelHeight = int(get_built_in_property(levelPath,"height"))
var levelWidth = int(get_built_in_property(levelPath,"width"))
var levelBGColor = get_built_in_property(levelPath,"backgroundcolor")

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
	# level pack getting
	levelpack = Save.config.get_value("Misc","levelPack","SMB")
	levelPrefix = str(world) + "-" + str(level) + "." + str(sub)
	
	# finding the tmx
	if FileAccess.file_exists("res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"):
		levelPath = "res://Level Data/" + levelpack + "/" + levelPrefix + ".tmx"
	else:
		levelPath = "user://data/Level Packs/" + levelpack + "/" + levelPrefix + ".tmx"

	# general level data
	song = get_map_property(levelPath,"song")
	bonus = get_map_property(levelPath,"bonus")
	intermission = get_map_property(levelPath,"intermission")
	theme = get_map_property(levelPath,"levelTheme")
	levelHeight = int(get_built_in_property(levelPath,"height"))
	levelWidth = int(get_built_in_property(levelPath,"width"))
	levelBGColor = get_built_in_property(levelPath,"backgroundcolor")
	marioX = get_map_property(levelPath,"marioX")
	marioY = get_map_property(levelPath,"marioY")
	underwater = get_map_property(levelPath,"underwater")
	pipes = JSON.parse_string("[" + get_map_property(levelPath,"pipes") + "]")
	pipescreen = JSON.parse_string("[" + get_map_property(levelPath,"pipescreen") + "]")
	
	# pipe stuff
	if pipescreen.get(marioScreen) is int:
		marioOffset = pipescreen[marioScreen]
	else:
		marioOffset = 0

func get_built_in_property(file:String,property:String) -> String:
	var tmxfile = XMLParser.new()
	var error = tmxfile.open(file)
	
	if !error == OK:
		return "i got nothin"
	
	
	while tmxfile.read() == OK:
		match tmxfile.get_node_type():
			XMLParser.NODE_ELEMENT:
				if tmxfile.get_node_name() == "map":
					return tmxfile.get_named_attribute_value(property)
	return "this shouldn't be seen"

func get_map_property(file:String,property:String):
	var tmxfile = XMLParser.new()
	var error = tmxfile.open(file)
	
	if !error == OK:
		return "i got nothin"
	
	
	while tmxfile.read() == OK:
		match tmxfile.get_node_type():
			XMLParser.NODE_ELEMENT:
				if tmxfile.get_node_name() == "property":
					if tmxfile.get_named_attribute_value("name") == property:
						var value = tmxfile.get_named_attribute_value("value")
						if tmxfile.get_attribute_name(1) == "type":
							if tmxfile.get_named_attribute_value("type") == "int":
								return int(value)
							if tmxfile.get_named_attribute_value("type") == "bool":
								if tmxfile.get_named_attribute_value("value") == "true":
									return true
								else:
									return false
						return value
	return "this shouldn't be seen"
