extends Control


func _ready():
	get_node("VBoxContainer/StartButton").grab_focus()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/initial_poc.tscn")
