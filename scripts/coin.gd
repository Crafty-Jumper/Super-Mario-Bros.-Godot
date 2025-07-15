extends Area2D

@onready var coin: Sprite2D = $Coin
@onready var water_coin: Sprite2D = $WaterCoin
@onready var question_solid: Sprite2D = $QuestionSolid
@onready var coin_sfx: AudioStreamPlayer2D = $CoinSFX
var collected : bool = false

func _process(_delta: float) -> void:
	if GlobalVariables.theme == 2:
		coin.hide()
		water_coin.show()
	else:
		coin.show()
		water_coin.hide()
	if collected:
		coin.hide()
		water_coin.hide()
		if GlobalVariables.theme == 2:
			question_solid.show()

func _on_body_entered(body: Node2D) -> void:
	if collected:
		return
	if body.name == "Mario":
		GlobalVariables.coin += 1
		collected = true
		coin_sfx.play()
		GlobalVariables.score += 100
