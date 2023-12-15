extends Node2D

const CIRCLE_POINTS: int = 20 # Number of vertices to calculate for the circle.
const GROUP_TO_DETECT = "detection_target" # Name of the group to detect.
const BASE_COLOR = Color(1, 1, 1, 0.3) # White
const DETECTED_COLOR = Color(1, 0, 0, 0.3) # Red
const DETECTION_LAYER = 1 # Layer of the entity that will be detected.
const OCCLUSION_LAYER = 2 # Layer that will block vision.

const _RAYCAST_GROUP = "vision_cone_raycast_group"

## Angle of the cone with its middle line.
@export var cone_angle: float
## Radius of the cone circle.
@export var cone_radius: float

## Enable only for NPCs. Vision cone will follow the detected entity.
## Enabling for Playable Character will result in unexpected behavior.
## Not tested with multiple detectable entities.
@export var focus_on_detection: bool = true

## Entity that will use the vision cone.
@onready var beholder: CharacterBody2D = self.get_node("../")

var raycast_nodes: Array
var collision_points: Array
var vision_polygon = Polygon2D.new()
var detection_polygon = CollisionPolygon2D.new()
var detection_area = Area2D.new()

func _ready():
	self.add_child(detection_area)
	detection_area.add_child(detection_polygon)
	detection_area.set_collision_mask_value(DETECTION_LAYER, true)
	
	self.add_child(vision_polygon)
	
	var shape = cone_shape(cone_angle)
	
	add_raycast(shape)
	raycast_nodes = get_tree().get_nodes_in_group(_RAYCAST_GROUP)


func _physics_process(_delta):
	collision_points = raycast_nodes.map(collision_point)
	vision_polygon = set_polygon(vision_polygon, collision_points)
	detection_polygon = set_polygon(detection_polygon, collision_points)
	
	if target_detected():
		vision_polygon.color = DETECTED_COLOR
		if focus_on_detection:
			var target_position = target_detected().position
			var beholder_position = beholder.position
			rotation = beholder_position.angle_to_point(target_position)

	else:
		if beholder.velocity.length() > 0:
			rotation = beholder.velocity.angle()
		vision_polygon.color = BASE_COLOR


func cone_shape(angle):
	angle = angle * 2 * PI / 360
	var cone_points: Array = []
	var increment_angle = 2 * angle / (CIRCLE_POINTS - 1)
	var new_angle: float = angle
	for point in CIRCLE_POINTS:
		new_angle = angle - increment_angle * point
		var new_point = Vector2(
			cone_radius * cos(new_angle), cone_radius * sin(new_angle)
			)
		cone_points.append(new_point)
	return cone_points


func set_polygon(new_polygon, cone_points):
	cone_points.append(Vector2(0, 0))
	new_polygon.polygon = cone_points
	return new_polygon


func add_raycast(cone_points):
	for point in cone_points:
		var raycast = RayCast2D.new()
		raycast.add_to_group(_RAYCAST_GROUP)
		raycast.target_position = point
		raycast.set_collision_mask_value(DETECTION_LAYER, false)
		raycast.set_collision_mask_value(OCCLUSION_LAYER, true)
		self.add_child(raycast)


func collision_point(ray: RayCast2D):
	if ray.is_colliding():
		return self.to_local(ray.get_collision_point())
	else:
		return ray.target_position


func target_detected():
	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group(GROUP_TO_DETECT):
			return body
	return false
