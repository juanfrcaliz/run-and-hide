extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Continue.grab_focus()

func _on_continue_pressed():
	get_tree().paused = false

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
