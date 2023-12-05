extends Area2D

@export var enemy: CharacterBody2D


func _process(_delta):
	if enemy.player_detected:
		var player_position = enemy.player.position
		var enemy_position = enemy.position
		rotation_degrees = enemy_position.angle_to_point(player_position) * 360 / (2 * PI)
	elif not enemy.speed == 0:
		rotation = enemy.velocity.angle()
