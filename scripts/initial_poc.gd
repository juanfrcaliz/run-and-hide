extends Node2D

func _ready():
	get_node("/root/initial_poc/main_chr/pause_menu/VBoxContainer").hide()
	get_tree().paused = false
	
func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		get_node("/root/initial_poc/main_chr/pause_menu/VBoxContainer").show()
