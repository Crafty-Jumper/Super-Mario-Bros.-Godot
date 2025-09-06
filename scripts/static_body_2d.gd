extends StaticBody2D

@export var item: PackedScene
@export var replacementScene: PackedScene
@export var itemCount = 0
@onready var node: Node = $Node
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export_enum ("Do Nothing","Small Break","Big Break","Spawn Item","Bump Only","Don't Break")
var marioHit = 0
@export var invisible : bool = false


var bumped = 0
var hasBeenHit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if GlobalVariables.paused:
		return
	
	if invisible and not hasBeenHit:
		node.hide()
		collision_shape_2d.disabled = true
	
	node.position.y = (16 - (-8*(cos(bumped)+1))) - 32
	if hasBeenHit:
		node.show()
		collision_shape_2d.disabled = false
		if bumped > 0:
			bumped -= 1
		if bumped <= 0:
			bumped = 0
			if marioHit == 3:
				if itemCount == 0:
					if not replacementScene == null:
						var replaceBlock = replacementScene.instantiate()
						replaceBlock.position = position
						get_parent().add_child(replaceBlock)
						queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Mario":
		if body.velocity.y > 0 and invisible:
			return
		if marioHit == 0:
			return
		if marioHit > 0 and not marioHit == 5:
			bumped = 4
			hasBeenHit = true
			if marioHit == 3:
				if not item == null:
					var popItem = item.instantiate()
					popItem.position = position
					popItem.position.y -= 16
					get_parent().add_child(popItem)
			if itemCount > 0:
				itemCount -= 1
			else:
				if marioHit == 1 and GlobalVariables.marioSize >= 0:
					_projectile(load("res://scenes/shatter.tscn"),6)
					queue_free()
				if marioHit == 2 and GlobalVariables.marioSize > 0:
					_projectile(load("res://scenes/shatter.tscn"),6)
					queue_free()
		if marioHit == 5:
			if GlobalVariables.marioState > 0:
				bumped = 4
				hasBeenHit = true

func _projectile(scene:PackedScene,palette:int):
	var popItem = scene.instantiate()
	popItem.position = position
	popItem.palette = palette
	GlobalVariables.add_child(popItem)
