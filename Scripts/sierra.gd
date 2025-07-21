extends  Node2D

@export var damege_amount: int = 1
@export var hit_effect: PackedScene

func _ready() -> void:
	$AnimationPlayer.play("RotacionSierra")
	$Area2D.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body._loseLife(position.x)
		
		 # Obtener la forma de colisión de la sierra
		var collision_shape = $Area2D/CollisionShape2D
		
		# Calcular el punto más cercano en la sierra al jugador
		var closest_point = collision_shape.global_position
		if collision_shape.shape is RectangleShape2D:
			var rect = collision_shape.shape
			var player_pos = body.global_position
			closest_point = Vector2(
				clamp(player_pos.x, collision_shape.global_position.x - rect.size.x/2,
									collision_shape.global_position.x + rect.size.x/2 ),
				clamp(player_pos.y, collision_shape.global_position.y - rect.size.y/2,
									collision_shape.global_position.y - rect.size.y/2 )
			)
		# Crear efecto en el punto calculado
		if hit_effect:
			var effect = hit_effect.instantiate()
			effect.global_position = closest_point
			get_parent().add_child(effect)
		




"""extends Node2D



func _ready() -> void:
	$AnimationPlayer.play("RotacionSierra")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body._loseLife(position.x)
		pass
"""
