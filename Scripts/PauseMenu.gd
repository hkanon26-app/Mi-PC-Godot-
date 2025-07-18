extends Control


func _ready() -> void:
	visible = false
	
	
func _input(event):
	if event.is_action_pressed("pause"):
		print("Juego Pausado")
		visible = not get_tree().paused
		get_tree().paused = not get_tree().paused	
