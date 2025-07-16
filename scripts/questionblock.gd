extends Sprite2D
@onready var timer: Timer = $"../Timer"

func _process(_delta: float) -> void:
	var color = floor(timer.time_left * 5)
	material.set_shader_parameter("accessRow",fmod(color,4)+1 + (GlobalVariables.theme * 4))
