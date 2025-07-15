extends AnimatedSprite2D


var canSpawnScore : bool = true
var speed = 0
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 6
	audio_stream_player_2d.play()
	GlobalVariables.coin += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	position.y -= speed
	speed -= 0.5
	if speed < -6:
		hide()
		if canSpawnScore:
			spawn_score(200)
			canSpawnScore = false


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()

func spawn_score(amount: int) -> void:
	var score = preload("res://scenes/score.tscn")
	var scoreNode = score.instantiate()
	scoreNode.position = position
	scoreNode.score = amount
	get_parent().add_child(scoreNode)
