extends CharacterBody2D

const BASE_SPEED: float = 150.0

var speed: float
var weight: float = 0.0
var score: int = 0

func _physics_process(_delta):
	speed = BASE_SPEED - (BASE_SPEED / 6) * weight
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	get_node("backpack_bar").value = weight * 20
	
	move_and_slide()
