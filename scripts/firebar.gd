extends Node2D

@onready var fireball_1: Sprite2D = $Node2D/Fireball1
@onready var fireball_2: Sprite2D = $Node2D/Fireball2
@onready var fireball_3: Sprite2D = $Node2D/Fireball3
@onready var fireball_4: Sprite2D = $Node2D/Fireball4
@onready var fireball_5: Sprite2D = $Node2D/Fireball5
@onready var fireball_6: Sprite2D = $Node2D/Fireball6
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var node_2d: Node2D = $Node2D

@export var speed = 1
var direction = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	if GlobalVariables.paused:
		return
	
	
	direction += delta
	var visual_dir = floor(direction*12) / 12
	
	fireball_2.position = Vector2(
		sin(visual_dir * speed) * 8,
		cos(visual_dir * speed) * 8
	)
	fireball_3.position = Vector2(
		sin(visual_dir * speed) * 16,
		cos(visual_dir * speed) * 16
	)
	fireball_4.position = Vector2(
		sin(visual_dir * speed) * 24,
		cos(visual_dir * speed) * 24
	)
	fireball_5.position = Vector2(
		sin(visual_dir * speed) * 32,
		cos(visual_dir * speed) * 32
	)
	fireball_6.position = Vector2(
		sin(visual_dir * speed) * 40,
		cos(visual_dir * speed) * 40
	)
	

func move_in_dir(pixels,movedirection):
	var output_x = 0
	var output_y = 0
	output_x += cos(2*PI*movedirection) * pixels
	output_y += sin(2*PI*movedirection) * pixels
	
	
	return Vector2(output_x,output_y)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	direction = 0
	node_2d.show()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
