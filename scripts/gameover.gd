extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player_2d.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if audio_stream_player_2d.playing:
		return
	
	
	if Input.is_key_pressed(KEY_SHIFT):
		GlobalVariables.marioLives = 3
		get_tree().change_scene_to_file("res://scenes/loading1.tscn")
	if Input.is_key_pressed(KEY_SPACE):
		GlobalVariables.marioLives = 3
		GlobalVariables.levelPrefix = GlobalVariables.startingLevel
		get_tree().change_scene_to_file("res://scenes/loading1.tscn")
	if Input.is_key_pressed(KEY_ENTER):
		get_tree().queue_delete(get_tree())
	if Input.is_key_pressed(KEY_DELETE):
		GlobalVariables.leveldatajson["vnhdubvhfidbvhfus"]
