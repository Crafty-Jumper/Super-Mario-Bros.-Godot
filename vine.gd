extends StaticBody2D

var origPos = position.y

@onready var vine_body: Sprite2D = $"Vine-body"
@onready var vineCol: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	origPos = position.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y > -16:
		position.y -= 0.5
	vine_body.region_rect.size.y = origPos-position.y
	vineCol.scale.y = origPos-position.y + 16
	vineCol.position.y = (origPos-position.y)/2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GlobalVariables.marioVine = true
		body.position.x = floor(position.x/16)*16
		GlobalVariables.marioVineLeft = true
		body.animated_sprite_2d.flip_h = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		GlobalVariables.marioVine = false
