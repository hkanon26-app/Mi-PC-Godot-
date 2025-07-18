extends Node2D

@export var coin_scene: PackedScene

@onready var timer = $TimerMonedas
@onready var zona_spawn = $ZonaSpawn

func _ready():
	randomize()
	timer.timeout.connect(_generar_lote_monedas)
	timer.start()

func _generar_lote_monedas():
	var cantidad = randi_range(2, 4)
	for i in range(cantidad):
		await get_tree().create_timer(randf_range(0.1, 0.8)).timeout  # Distribuir aparición
		_instanciar_moneda()

func _instanciar_moneda():
	if coin_scene == null:
		print("🚫 Coin scene no asignada.")
		return

	if zona_spawn == null:
		print("🚫 Zona de spawn no asignada.")
		return

	var coin = coin_scene.instantiate()
	if coin == null:
		print("❌ Instancia fallida. Coin es null.")
		return

	var rect = zona_spawn.get_node("CollisionShape2D").shape.extents
	var centro = zona_spawn.global_position

	var x = randf_range(centro.x - rect.x, centro.x + rect.x)
	var y = randf_range(centro.y - rect.y, centro.y + rect.y)

	if coin is Node2D:
		coin.position = Vector2(x, y)
	else:
		print("⚠️ La instancia de coin no tiene propiedad 'position'")
		return

	# Estas dos propiedades las usará la moneda para su desaparición
	if "tiempo_de_vida" in coin:
		coin.tiempo_de_vida = 2.0
	if "tiempo_despawn_anim" in coin:
		coin.tiempo_despawn_anim = randf_range(0.6, 1.5)

	get_tree().current_scene.add_child(coin)
