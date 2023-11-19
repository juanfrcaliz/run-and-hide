extends CharacterBody2D

const BASE_SPEED: float = 40

@export var player: Node2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var player_detected: bool = false
var radius: int = 1
var random_nav_target: Vector2


func _physics_process(_delta) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	
	velocity = BASE_SPEED * dir
	move_and_slide()


func make_path() -> void:
	if player_detected:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = player.global_position
		# nav_agent.target_position = global_position
		# random_nav_target = Vector2(randi_range(-radius, radius), randi_range(-radius, radius))
		# nav_agent.target_position = random_nav_target


func _on_timer_timeout():
	make_path()


func _on_player_detection_body_entered(body):
	if body == player:
		player_detected = true


func _on_player_detection_body_exited(body):
	if body == player:
		player_detected = false


func _on_kill_player_body_entered(body):
	if body == player:
		player.game_over = true

