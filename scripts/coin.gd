extends Area2D

var picked: bool = false

func pick_up(body):
	if body.weight < 5 and not picked:
		picked = true
		get_node("Coin").visible = false
		body.weight += 1
		return true
