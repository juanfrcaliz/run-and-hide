extends Area2D

@onready var _animated_sprite = $AnimatedSprite2D
var picked: bool = false

func _process(_delta):
	_animated_sprite.play("flip")

func pick_up(body):
	if body.weight < 5 and not picked:
		picked = true
		$AnimatedSprite2D.hide()
		#get_node("Coin").visible = false
		body.weight += 1
		return true
