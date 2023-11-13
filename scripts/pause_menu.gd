extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("VBoxContainer/Continue").grab_focus()

func _on_continue_pressed():
	unpause()

func _on_quit_pressed():
	unpause()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func unpause():
	get_tree().paused = false
	get_node("VBoxContainer").hide()
