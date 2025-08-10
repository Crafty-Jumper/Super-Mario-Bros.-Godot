extends AudioStreamPlayer

var song = ""
var looping : bool = false

func _ready() -> void:
	stream = load("res://music.tres")

func _process(_delta: float) -> void:
	if looping:
		if not playing:
			play()

func loadtrack(track: String,loop: bool = false) -> void:
	if song == track:
		return
	song = track
	
	looping = loop
	var checkPath = "user://data/Level Packs/" + GlobalVariables.levelpack + "/audio/music/"
	for i in 2:
		stream.set_sync_stream(0,load_custom_mp3(checkPath + track + "-Pul1.mp3"))
		stream.set_sync_stream(1,load_custom_mp3(checkPath + track + "-Pul2.mp3"))
		stream.set_sync_stream(2,load_custom_mp3(checkPath + track + "-Tri.mp3"))
		stream.set_sync_stream(3,load_custom_mp3(checkPath + track + "-Noi.mp3"))
		stream.set_sync_stream(4,load_custom_mp3(checkPath + track + "-DPCM.mp3"))
		if FileAccess.file_exists(checkPath + track + "-Pul1.mp3"):
			play()
			return
		checkPath = "res://audio/music/"

func musicVolume(tracks:Array) -> void:
	stream.set_sync_stream_volume(0,tracks[0])
	stream.set_sync_stream_volume(1,tracks[1])
	stream.set_sync_stream_volume(2,tracks[2])
	stream.set_sync_stream_volume(3,tracks[3])
	stream.set_sync_stream_volume(4,tracks[4])

func load_custom_mp3(path: String) -> AudioStreamMP3:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var audio = AudioStreamMP3.new()
		audio.data = file.get_buffer(file.get_length())
		return audio
	return null
