extends CanvasLayer

# Configuración
@export var max_radius: float = 100
@export var dead_zone: float = 10
@export var sensitivity = 1.0  # Factor de sensibilidad

# Señal para salto
signal jump_pressed

# Referencias
@onready var background = $Control/JoystickBackground
@onready var handle = $Control/JoystickHandle
@onready var jump_button = $Control/JumpButton

# Variables internas
var is_dragging := false
var touch_index := -1
var input_vector := Vector2.ZERO
var jump_just_pressed = false
var jump_just_released = false

func _ready():
	add_to_group("mobile_controls")
	
	# Configuración inicial
	handle.position = background.position
	background.visible = false
	handle.visible = false
	
	# Solo mostrar en dispositivos móviles
	if OS.has_feature("mobile"):
		visible = true
		# Configurar botón de salto
		jump_button.visible = true
		jump_button.pressed.connect(_on_jump_pressed)
	else:
		visible = false

func _input(event):
	# Solo procesar en móviles
	if not OS.has_feature("mobile"):
		return
	
	# Inicio de toque
	if event is InputEventScreenTouch and event.pressed:
		if touch_index == -1:
			# Ignorar toques en el botón de salto
			if jump_button.get_global_rect().has_point(event.position):
				return
				
			touch_index = event.index
			_start_drag(event.position)
	
	# Movimiento
	elif event is InputEventScreenDrag and event.index == touch_index:
		_update_drag(event.position)
	
	# Fin de toque
	elif event is InputEventScreenTouch and not event.pressed and event.index == touch_index:
		_end_drag()

func _start_drag(position: Vector2):
	is_dragging = true
	background.global_position = position - background.size * 0.5
	handle.global_position = position - handle.size * 0.5
	background.visible = true
	handle.visible = true

func _update_drag(position: Vector2):
	var center = background.position + background.size * 0.5
	var direction = position - center
	var distance = direction.length()
	
	# Limitar al radio máximo
	if distance > max_radius:
		direction = direction.normalized() * max_radius
		distance = max_radius
	
	# Actualizar posición del handle
	handle.position = center + direction - handle.size * 0.5
	
	# Calcular vector de movimiento (normalizado)
	input_vector = direction.normalized() * sensitivity if distance > dead_zone else Vector2.ZERO

func _end_drag():
	is_dragging = false
	touch_index = -1
	input_vector = Vector2.ZERO
	background.visible = false
	handle.visible = false

"# API para obtener dirección
func get_movement_vector() -> Vector2:
	return input_vector"

func _on_jump_pressed():
	jump_just_pressed = true
	# Programar reset para el próximo frame
	call_deferred("reset_jump_flags")
	
func reset_jump_flags():
	jump_just_pressed = false
	jump_just_released = false
	
func get_movement_vector() -> Vector2:
	# Aplicar suavizado al vector
	return input_vector.lerp(Vector2.ZERO, 0.2)
