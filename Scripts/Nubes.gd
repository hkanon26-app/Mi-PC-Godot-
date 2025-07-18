# Nubes.gd
extends Node2D

@export var velocidad_min: float = 20.0
@export var velocidad_max: float = 60.0
@export var altura_min: float = -190.0
@export var altura_max: float = -290.0
@export var animaciones_disponibles: Array[String] = ["Nube1", "Nube2"]

var velocidad: float

func _ready() -> void:
	randomize()
	position.y = randf_range(altura_min, altura_max)
	position.x = -350
	velocidad = randf_range(velocidad_min, velocidad_max)

	# Mostrar solo una nube
	var usar_sprite1 = randi() % 2 == 0
	$Nube1.visible = usar_sprite1
	$Nube2.visible = not usar_sprite1

	# Reproducir animación aleatoria
	if animaciones_disponibles.size() > 0:
		$AnimationPlayer.play(animaciones_disponibles.pick_random())

func _process(delta: float) -> void:
	position.x += velocidad * delta
	if position.x > get_viewport_rect().size.x + 150:
		queue_free()
