extends Node

var jsondata = {}

func load_json_file(filepath: String):
	if FileAccess.file_exists(filepath):
		var fileData = FileAccess.open(filepath,FileAccess.READ)
		var output = JSON.parse_string(fileData.get_as_text())
		if output is Dictionary:
			fileData.close()
			jsondata = output
			return output
		else:
			print("Error: File is not JSON!")
			fileData.close()
	else:
		print("Error: Non-existent file!")
