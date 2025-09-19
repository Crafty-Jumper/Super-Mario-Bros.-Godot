extends Node

func _ready() -> void:
	pass

func get_file(filename:String) -> Variant:
	var file = FileAccess.open("user://resources/" + filename,FileAccess.READ)
	for i in 2:
		if file:
			var filedata = file.get_as_text()
			return filedata
		else:
			copy_file(filename)
	
	return

func copy_file(filepath:String) -> void:
	
	
	var filename = filepath.replace(filepath.get_base_dir(),"")
	
	DirAccess.make_dir_recursive_absolute("user://resources/" + filepath.replace(filename,""))
	
	
	
	var file = FileAccess.open("res://" + filepath,FileAccess.READ)
	var data = file.get_buffer(file.get_length())
	
	var filewrite = FileAccess.open("user://resources/" + filepath,FileAccess.WRITE)
	filewrite.store_buffer(data)
	file.close()
