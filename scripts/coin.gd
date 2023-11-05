extends Area2D

var picked: bool = false

func _on_body_entered(body):
	if body.is_in_group("player") and body.weight < 5 and not picked:
		picked = true
		get_node("Coin").visible = false
		body.weight += 1
		
