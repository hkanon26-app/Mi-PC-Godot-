extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartGameButton.grab_focus()


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Sceness/Mundo1.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
