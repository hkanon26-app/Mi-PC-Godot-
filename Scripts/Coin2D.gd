extends Area2D

@onready var coin_sprite = $CoinSprite2D
@onready var collect_sprite = $CoinCollectSprite2D
@onready var despawn_sprite = $CoinDespawnSprite2D
@onready var animation_player = $AnimationPlayer

@export var tiempo_de_vida: float = 2.0
@export var tiempo_despawn_anim: float = 1.0

var recolectada: bool = false

func _ready():
	coin_sprite.visible = true
	collect_sprite.visible = false
	despawn_sprite.visible = false
	_iniciar_autodestruccion()

func _on_body_entered(body: Node2D):
	if body.get_name() == "Player" and not recolectada:
		recolectada = true
		$AudioStreamPlayer.playing = true
		body.add_Coin()
		
		# Ocultar sprite de moneda y mostrar animación de recolección
		coin_sprite.visible = false
		collect_sprite.visible = true
		
		set_deferred("monitoring", false)
		set_deferred("collision_mask", 0)
		
		animation_player.play("Recolectado")
		
		await animation_player.animation_finished
		await get_tree().create_timer(0.1).timeout
		queue_free()
		print("✅ Player cogió una moneda")
	else:
		print("⛔ Player no colisionó con la moneda")

func _iniciar_autodestruccion():
	await get_tree().create_timer(tiempo_de_vida).timeout
	if recolectada:
		return
	
	print("⏳ Moneda no fue recolectada. Desapareciendo...")

	# Ocultar sprite de moneda y mostrar sprite de desaparición
	coin_sprite.visible = false
	despawn_sprite.visible = true
	
	# Inicia animación de desaparición suave
	animation_player.play("Desaparecer")
	await get_tree().create_timer(tiempo_despawn_anim).timeout
	queue_free()
