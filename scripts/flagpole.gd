extends CharacterBody2D

@onready var audio_stream_player_2d: AudioStreamPlayer = $AudioStreamPlayer2D

var inUse : bool = false

func _physics_process(delta: float) -> void:
	if inUse:
		velocity.y = 120 * delta * 60
	
	
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		inUse = true
		body.goal_pole.emit()
		audio_stream_player_2d.play()
