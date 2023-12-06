extends Node2D

const CIRCLE_POINTS: int = 100
const BASE_COLOR = Color(1, 1, 1, 0.3) # White
const DETECTED_COLOR = Color(1, 0, 0, 0.3) # Red
const PLAYER_NAME = "main_chr"

@export var cone_angle: float
@export var cone_radius: float
@export var enemy: CharacterBody2D

var raycast_nodes
var raycast_colliding: bool = false
var cone_polygon
var detection_area
var collision_points: Array
var polygon = Polygon2D.new()
var collision_polygon = CollisionPolygon2D.new()
var area = Area2D.new()

func _ready():
	area.set_collision_mask_value(1, true)
	
	self.add_child(area)
	self.add_child(polygon)
	area.add_child(collision_polygon)
	
	cone_angle = cone_angle * 2 * PI / 360
	var shape = cone_shape()
	
	add_raycast(shape)
	raycast_nodes = get_tree().get_nodes_in_group("raycast")
	
	polygon = set_polygon(polygon, shape)
	collision_polygon = set_polygon(collision_polygon, shape)


func _physics_process(_delta):
	collision_points = raycast_nodes.map(collision_point)
	polygon = set_polygon(polygon, collision_points)
	collision_polygon = set_polygon(collision_polygon, collision_points)
	
	if player_detected():
		polygon.color = DETECTED_COLOR
		var player_position = enemy.player.position
		var enemy_position = enemy.position
		rotation_degrees = enemy_position.angle_to_point(player_position) * 360\
		 / (2 * PI)
	else:
		rotation = enemy.velocity.angle()
		polygon.color = BASE_COLOR


func cone_shape():
	var cone_points: Array = []
	var incr_angle = 2 * cone_angle / (CIRCLE_POINTS - 1)
	var new_angle: float = cone_angle
	for point in CIRCLE_POINTS:
		new_angle = cone_angle - incr_angle * point
		var new_point = Vector2(cone_radius * cos(new_angle), cone_radius * sin(new_angle))
		cone_points.append(new_point)
	return cone_points


func set_polygon(new_polygon, cone_points):
	cone_points.append(Vector2(0, 0))
	new_polygon.polygon = cone_points
	return new_polygon


func add_raycast(cone_points):
	for point in cone_points:
		var raycast = RayCast2D.new()
		raycast.add_to_group("raycast")
		raycast.target_position = point
		raycast.set_collision_mask_value(1, false)
		raycast.set_collision_mask_value(2, true)
		self.add_child(raycast)


func collision_point(ray: RayCast2D):
	if ray.is_colliding():
		return self.to_local(ray.get_collision_point())
	else:
		return ray.target_position


func player_detected():
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.name == PLAYER_NAME:
			return true
