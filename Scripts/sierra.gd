extends Node2D



func _ready() -> void:
	$AnimationPlayer.play("RotacionSierra")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body._loseLife(position.x)
		pass
