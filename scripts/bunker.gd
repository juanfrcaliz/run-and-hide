extends Area2D

const EMPTY_DELAY = 0.5

var time: float = 0
var player_in_bunker: bool
var player

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_bunker = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_bunker = false

func _process(delta):
	if self.is_inside_tree():
		player = get_tree().get_nodes_in_group("player")[0]
		if player_in_bunker and time > EMPTY_DELAY and player.weight > 0:
			player.weight -= 1
			time = 0
	time += delta
