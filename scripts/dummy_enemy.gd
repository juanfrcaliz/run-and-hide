extends CharacterBody2D

@export var player: CharacterBody2D

@onready var vision_cone = $VisionCone
const BASE_SPEED = 300.0
var speed: float


func _physics_process(_delta):
	speed = BASE_SPEED
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	if velocity.length() > 0:
		vision_cone.rotation = direction.angle()
	move_and_slide()
