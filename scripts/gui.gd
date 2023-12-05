extends Node2D


@export var player: CharacterBody2D
@onready var coins = get_tree().get_nodes_in_group("coin")
@onready var total_coins: int = len(coins)
@onready var coins_collected = $"Label"

const GAME_OVER_DELAY: float = 0.6

var game_over_time: float = 0
var picked_coins: int = 0


func _ready():
	get_node("./pause_menu/VBoxContainer").hide()
	get_tree().paused = false


func _process(delta):
	coins_collected.text = "Coins collected: " + str(picked_coins) + "/" + str(total_coins)
	position = player.position
	
	if player.jump_weight(): get_node("Forbidden").hide()
	else: get_node("Forbidden").show()
	get_node("backpack_bar").value = player.weight * 20
	
	if player.game_over:
		game_over_time += delta
		if game_over_time >= GAME_OVER_DELAY:
			player.game_over = false
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
