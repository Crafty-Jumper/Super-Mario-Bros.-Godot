extends Node

var config = ConfigFile.new()
const savePath = "user://data/settings.ini"

func _ready() -> void:
	if not FileAccess.file_exists(savePath):
		# misc
		config.set_value("Misc","version",1)
		config.set_value("Misc","levelPack","SMB")
		config.set_value("Misc","character","MARIO")
		config.set_value("Misc","mode","CLASSIC")
		# audio
		config.set_value("Audio","master",10)
		config.set_value("Audio","pul1",10)
		config.set_value("Audio","pul2",10)
		config.set_value("Audio","tri",10)
		config.set_value("Audio","noi",10)
		config.set_value("Audio","dpcm",10)
		
		config.save(savePath)
	else:
		config.load(savePath)

func saveSetting(path: String,key: String,value):
	config.set_value(path,key,value)
	config.save(savePath)
