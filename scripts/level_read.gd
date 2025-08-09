extends TileMapLayer

@onready var flag: CharacterBody2D = $"../Area2D"
@onready var tile_map_layer_2: TileMapLayer = $"../TileMapLayer2"

var levelFile = FileAccess.open(GlobalVariables.levelPath, FileAccess.READ)
var index = 0
var tilePosX = 0
var tilePosY = 0
var levelString = ""



const tileIDs = [
 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,
16,17,18,19,20,21,22,23,24,25,26,27,[3],[4],[6],-1,
[8],[10],-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,
44,45,46,47,48,49,50,51,52,53,[7],55,56,57,58,59,
60,[5],35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
61,62,63,64,65,66,67,68,69,70,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
[1],[9],-1,[2],-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
]
const enemyIDs = [
 1, 5, 6,-1,-1,-1,-1,-1, 7,-1,-1,-1,-1,-1,-1,-1,
 1, 5, 6,-1,-1,-1,-1,-1, 7,-1,-1,-1,-1,-1,-1,-1,
 2, 3,-1,-1,-1,-1,-1,-1, 4,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
]

func _ready() -> void:
	
	GlobalVariables.fixpath()
	print(get_properties("res://Level Data/SMB/2-3.0.tmx"))
	
	# tiles
	levelFile = FileAccess.open(GlobalVariables.levelPath, FileAccess.READ)
	levelString = levelFile.get_as_text()
	
	for i in 15*256:
		_place_tiles()
	return


	# enemies
	var enemyFile = FileAccess.open(GlobalVariables.levelPath + "_Enemies.csv", FileAccess.READ)
	var enemyString = enemyFile.get_as_text()
	
	index = 0
	tilePosY = 0
	for i in 15*256:
		enemyString = enemyString.replace("\n",",")
		var tileID = int((enemyString.get_slice(",",index)))
		
		if fmod(index,GlobalVariables.levelWidth) == 0 and index > 0:
			tilePosY += 1
		tilePosX = fmod(index,GlobalVariables.levelWidth)
		
		
		
		var enemyPos = Vector2i(tilePosX*2 + int(fmod(tileID,32) >= 16),tilePosY)
		
		if not enemyString.get_slice(",",index) == "":
			tile_map_layer_2.set_cell(enemyPos,0,Vector2i(0,0),enemyIDs[tileID])
		index += 1
		
		
func _process(_delta: float) -> void:
	material.set_shader_parameter("accessRow",GlobalVariables.theme + 1)

func _place_tiles() -> void:
	var xml = XMLParser.new()
	if xml.open("res://levels/world1-1.tmx") == OK:
		while xml.read() == OK:
			if xml.get_node_name() == "property":
				var prop_name = xml.get_named_attribute_value("name")
				var prop_value = xml.get_named_attribute_value("value")
				print(prop_name + ": " + prop_value)

	
	
	
	levelString = levelString.replace("\n",",")
		
	var tileID = int((levelString.get_slice(",",index)))
	var tilePos = Vector2i(0,0)
	
	if tileIDs[tileID] is Array:
		pass
	else:
		tilePos = Vector2i(fmod(tileIDs[tileID-2],9),floor(tileIDs[tileID-2]/9))
	
	
	if fmod(index,256) == 0 and index > 0:
		tilePosY += 1
	tilePosX = fmod(index,256)
	index += 1
	
	if tileID-2 == 96:
		flag.position.x = tilePosX * 16 - 1
		flag.position.y = tilePosY * 16 + 24
	
	if tileID-2 == 13:
		if fmod(index,GlobalVariables.levelWidth) > 15:
			if int((levelString.get_slice(",",index - 2))) == 5:
				tilePos = Vector2i(8,7)
	
	
	if tileIDs[tileID-2] is Array:
		set_cell(Vector2i(tilePosX,tilePosY),1,Vector2i(0,0),tileIDs[tileID][0])
	else:
		set_cell(Vector2i(tilePosX,tilePosY),0,tilePos)
	
	

func get_properties(path: String, id: int = 0):
	var parser = XMLParser.new()
	var properties = []
	parser.open(path)
	while parser.read() != ERR_FILE_EOF:
		if parser.get_node_type() == XMLParser.NODE_ELEMENT:
			var node_name = parser.get_node_name()
			var attributes_dict = {}
			for idx in range(parser.get_attribute_count()):
				attributes_dict[parser.get_attribute_name(idx)] = parser.get_attribute_value(idx)
				properties.resize(properties.size() + 1)
				properties[idx] = attributes_dict
	return properties
