extends CanvasLayer


func _ready():
	get_node("VBoxContainer/Continue").grab_focus()


func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		get_node("./VBoxContainer").show()

func _on_continue_pressed():
	unpause()

func _on_quit_pressed():
	unpause()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func unpause():
	get_tree().paused = false
	get_node("VBoxContainer").hide()
