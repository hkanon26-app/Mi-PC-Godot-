extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		print("Hemos caido")
		call_deferred("reiniciar_juego")
	print(body.get_name())
		
func reiniciar_juego():
	get_tree().change_scene_to_file("res://Sceness/Menu.tscn")
	
	
