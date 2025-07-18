extends Node2D

@export var nube_escena: PackedScene

@onready var timer = $TimerNubes
@onready var zona_spawn = $ZonaSpawn

func _ready():
	randomize()
	timer.timeout.connect(_generar_nube)
	timer.start()

func _generar_nube():
	print("🌥 Generando una nube...") 
	if nube_escena == null:
		print("🚫 Nube no asignada en el Inspector.")
		return
	
	if zona_spawn == null:
		print("🚫 Zona de spawn no encontrada.")
		return
	
	var nube = nube_escena.instantiate()
	
	var rect = zona_spawn.get_node("CollisionShape2D").shape.extents
	var centro = zona_spawn.global_position
	
	var x = centro.x
	var y = randf_range(centro.y - rect.y, centro.y + rect.y)
	
	nube.position = Vector2(x, y)
	print("🧭 Nube en: ", nube.position)

	get_tree().current_scene.add_child(nube)
