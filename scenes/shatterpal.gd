extends Node2D

var palette = 6
@onready var shatter_1: Sprite2D = $Shatter1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shatter_1.material.set_shader_parameter("accessRow",palette)
