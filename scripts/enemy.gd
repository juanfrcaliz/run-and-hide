extends CharacterBody2D

@export var player: Node2D
@onready var tilemap: TileMap = get_node("../level0/TileMap")
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var used_cells = tilemap.get_used_cells(0)
@onready var vision_cone = $VisionCone

const SPEED: float = 70
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
	#debug_navigation()


func is_target_reached():
	return nav_agent.target_position.distance_to(self.position) < REACHABLE_THRESHOLD


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
	
	if vision_cone.target_detected() and is_point_reachable(player.position):
		speed = SPEED
		nav_agent.target_position = player.global_position
	elif is_target_reached() and not waiting:
		speed = 0
		$Wait_timer.start()
		waiting = true


func get_random_position():
	var random_cell = used_cells[randi() % used_cells.size()]
	var random_position = tilemap.map_to_local(random_cell)
	return random_position


func _on_path_calc_timer_timeout():
	make_path()


func _on_wait_timer_timeout():
	nav_agent.target_position = get_random_position()
	speed = SPEED
	waiting = false


func _on_kill_player_body_entered(body):
	if body == player:
		#return
		get_node(".").set_physics_process(false)
		player.kill_player()


func debug_navigation():
	print("Target tile: ", tilemap.local_to_map(nav_agent.target_position))
	print("Target reachable: ", is_point_reachable(nav_agent.target_position))
