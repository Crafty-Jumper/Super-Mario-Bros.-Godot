extends Node

@onready var character_body_2d: CharacterBody2D = $".."
const SPINY = preload("res://scenes/entities/spiny.tscn")

func _ready() -> void:
	character_body_2d.velocity.y = -300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if character_body_2d.is_on_floor():
		var spiny = SPINY.instantiate()
		spiny.position = get_parent().position
		get_parent().get_parent().add_child(spiny)
		if get_parent().frozen:
			spiny.frozen = true
		get_parent().queue_free()
