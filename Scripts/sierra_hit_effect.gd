extends Node2D

# Efecto de chispas para colisión con sierra
@onready var animation_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Iniciar efecto y autodestruirse
	animation_player.play("Sparks")
	if has_node("AudioStreamPlayer2D"):
		$AudioStreamPlayer2D.play()
		
	await animation_player.animation_finished
	queue_free()
