extends Node2D

func _ready():
	$main_chr/pause_menu.hide()
	
func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		$main_chr/pause_menu.show()
	if not get_tree().paused:
		$main_chr/pause_menu.hide()
