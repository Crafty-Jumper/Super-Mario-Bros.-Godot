extends Node2D

@onready var camera_2d: Camera2D = $"../Camera2D"

@export var generatedEnemy : PackedScene
@export_enum ("Top","Bottom","Left","Right") var direction = 1
var active : bool = false
var timer = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	active = GlobalVariables.generatorActive
	direction = GlobalVariables.generatorDirection
	generatedEnemy = GlobalVariables.generatedEnemy
	
	if !active:
		return
	position = camera_2d.position
	timer -= 1*60*delta
	if timer <= 0:
		var enemy = generatedEnemy.instantiate()
		timer = randf_range(50.0,100.0)
		if direction == 1:
			enemy.position = position
			enemy.position.y += 128
			enemy.position.x += randf_range(-128.0,128.0)
			get_parent().add_child(enemy)
		if direction == 0:
			enemy.position = position
			enemy.position.y -= 128
			enemy.position.x += randf_range(-128.0,128.0)
			get_parent().add_child(enemy)
		if direction == 2:
			enemy.position = position
			enemy.position.x -= get_viewport_rect().size.x/5
			enemy.position.y += floor(randf_range(-128.0,128.0)/16)*16
			get_parent().add_child(enemy)
		if direction == 3:
			enemy.position = position
			enemy.position.x += get_viewport_rect().size.x/4.9
			enemy.position.y += floor(randf_range(-64.0,64.0)/16)*16
			get_parent().add_child(enemy)
