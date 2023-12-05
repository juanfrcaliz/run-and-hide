extends CharacterBody2D

@export var player: Node2D
@onready var tilemap: TileMap = get_node("../level0/TileMap")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var used_cells = tilemap.get_used_cells(0)

const SPEED: float = 80
const REACHABLE_THRESHOLD: float = 5

var speed: float = SPEED
var player_detected: bool = false
var initial_path: bool = true
var target: Vector2
var target_reached: bool = false
var waiting: bool = false


func _physics_process(_delta) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = speed * dir
	move_and_slide()


func is_target_reached():
	return nav_agent.target_position.distance_to($".".position) < REACHABLE_THRESHOLD


func is_point_reachable(target_position: Vector2):
	var map = get_world_2d().navigation_map
	var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(
		map, target_position
		)
	if target_position.distance_to(closest_point) < REACHABLE_THRESHOLD:
		return true
	else: return false


func make_path() -> void:
	if initial_path:
		nav_agent.target_position = get_random_position()
		initial_path = false
	
	if player_detected and is_point_reachable(player.position):
		print("player detected")
		speed = SPEED
		nav_agent.target_position = player.global_position
	elif is_target_reached() and not waiting:
		print("target reached")
		speed = 0
		$Wait_timer.start()
		waiting = true


func get_random_position():
	var random_cell = used_cells[randi() % used_cells.size()]
	print("New random cell: ", random_cell)
	var random_position = tilemap.map_to_local(random_cell)
	print("New random position: ", random_position)
	return random_position


func _on_path_calc_timer_timeout():
	#if nav_agent.target_position.distance_to($".".position) < REACHABLE_THRESHOLD:
	#	target_reached = true
	#else: target_reached = false
	make_path()
	print("Distance to target: ", nav_agent.target_position.distance_to($".".position))
	print("Speed: ", speed)


func _on_wait_timer_timeout():
	nav_agent.target_position = get_random_position()
	speed = SPEED
	waiting = false


func _on_player_detection_body_entered(body):
	if body == player:
		player_detected = true
		make_path()


func _on_player_detection_body_exited(body):
	if body == player:
		player_detected = false
		make_path()


func _on_kill_player_body_entered(body):
	if body == player:
		# return
		get_node(".").set_physics_process(false)
		player.game_over = true
