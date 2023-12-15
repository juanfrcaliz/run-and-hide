extends CharacterBody2D

const BASE_SPEED: float = 100.0
const JUMP_TIME: float = 0.5
const PIT_TILES = [Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1),
				   Vector2i(2, 2), Vector2i(3, 2), Vector2i(4, 2),
				   Vector2i(2, 3), Vector2i(3, 3), Vector2i(4, 3),
				   Vector2i(2, 4), Vector2i(3, 4), Vector2i(4, 4),
				   Vector2i(2, 5), Vector2i(3, 5), Vector2i(4, 5),
				   Vector2i(2, 6), Vector2i(3, 6), Vector2i(4, 6),
				   Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 5),
				   Vector2i(0, 6), Vector2i(1, 5), Vector2i(1, 6)
				]
const TILEMAP_ID: int = 3

@onready var gui = get_node("../gui")
@onready var _animated_sprite = $AnimatedSprite2D

var speed: float
var weight: float = 0.0
var jump_time: float = 0
var grounded: bool = true
var game_over: bool = false
var collision_coords: Vector2i
var tilemap

func _ready():
	get_node("AnimatedSprite2D").show()
	get_node("main_chr_dead_sprite").hide()
	tilemap = get_node("/root/initial_poc/level0/TileMap")

func _physics_process(_delta):
	if not game_over:
		speed = BASE_SPEED - (BASE_SPEED / 8) * weight
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		move_and_slide()
	
func _process(delta):
	
	if Input.is_action_just_pressed("jump") and jump_weight() and grounded:
		start_jump()
	
	if not grounded:
		jump_time += delta
		if jump_time >= JUMP_TIME:
			if over_pit():
				kill_player()
			else:
				end_jump()
				jump_time = 0


func jump_weight():
	if weight <= 2:
		return true
	else:
		return true

func over_pit():
	collision_coords = tilemap.local_to_map(
		get_node("ground_area/ground_collision").global_position
	)
	
	var source_id = tilemap.get_cell_source_id(1, collision_coords)
	var atlas_coords = tilemap.get_cell_atlas_coords(1, collision_coords)
	
	if source_id == TILEMAP_ID and atlas_coords in PIT_TILES:
		return true
	else:
		return false

func kill_player():
	_animated_sprite.stop()
	get_node("AnimatedSprite2D").hide()
	get_node("main_chr_dead_sprite").show()
	game_over = true

func start_jump():
	set_collision_mask_value(3, false)
	get_node("ground_area").set_collision_mask_value(3, false)
	grounded = false
	_animated_sprite.play("jump")

func end_jump():
	set_collision_mask_value(3, true)
	get_node("ground_area").set_collision_mask_value(3, true)
	grounded = true
	_animated_sprite.stop()


func _on_object_pickup_area_area_entered(area):
	if area.is_in_group("coin"):
		area.pick_up(self)
