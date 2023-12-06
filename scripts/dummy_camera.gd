extends Camera2D

@export var player: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position = player.position
