extends CharacterBody2D

const BASE_SPEED: float = 200.0
const SPEED_DOWN: float = BASE_SPEED / 6

var speed: float
var weight: float = 0.0
var time: float = 0.0
var incr_weight: bool = true

func _physics_process(_delta):
	# check_weight(delta) # Weight goes up and down in 2s intervals.
	speed = BASE_SPEED - SPEED_DOWN * weight
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	move_and_slide()

func weight_up():
	weight += 1

func weight_down():
	weight -= 1
	
func check_weight(delta):
	time += delta
	if time >= 2:
		if incr_weight:
			weight_up()
			print(weight)
			if weight >= 5: incr_weight = false
		else:
			weight_down()
			print(weight)
			if weight <= 0: incr_weight = true
		time = 0
