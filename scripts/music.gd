extends AudioStreamPlayer

var song = 0
const songs = ["Overworld","Underground","Underwater","Castle","Star"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = load("res://scenes/level.tscn::AudioStreamSynchronized_2e2fo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func loadtrack(track: String) -> void:
	var checkPath = "user://" + GlobalVariables.levelpack + "/audio/music/"
	for i in 2:
		stream.set_sync_stream(0,load(checkPath + track + "-Pul1.mp3"))
		stream.set_sync_stream(1,load(checkPath + track + "-Pul2.mp3"))
		stream.set_sync_stream(2,load(checkPath + track + "-Tri.mp3"))
		stream.set_sync_stream(3,load(checkPath + track + "-Noi.mp3"))
		stream.set_sync_stream(4,load(checkPath + track + "-DPCM.mp3"))
		if FileAccess.file_exists(checkPath + track + "-Pul1.mp3"):
			play()
			return
		else: if FileAccess.file_exists(checkPath + track + ".mp3"):
			stream.set_sync_stream(5,checkPath + track + ".mp3")
			stream.set_sync_stream(5,checkPath + track + "-pause.mp3")
			play()
			return
		checkPath = "res://audio/music/"


func musicVolume(tracks:Array) -> void:
	stream.set_sync_stream_volume(0,tracks[0])
	stream.set_sync_stream_volume(1,tracks[1])
	stream.set_sync_stream_volume(2,tracks[2])
	stream.set_sync_stream_volume(3,tracks[3])
