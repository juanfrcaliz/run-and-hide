extends Area2D

const EMPTY_DELAY = 0.5

@onready var coins = get_tree().get_nodes_in_group("coin")
@onready var total_coins: int = len(coins)

var empty_time: float = 0
var player_in_bunker: bool
var player
var score: int = 0

func _ready():
	player = get_node("../../main_chr")

func _on_body_entered(body):
	if body.name == player.name:
		player_in_bunker = true

func _on_body_exited(body):
	if body.name == player.name:
		player_in_bunker = false

func _process(delta):
	if self.is_inside_tree():
		if player_in_bunker and empty_time > EMPTY_DELAY and player.weight > 0:
			player.weight -= 1
			score += 1
			if score >= total_coins:
				get_tree().change_scene_to_file("res://scenes/win.tscn")
			empty_time = 0
	empty_time += delta
