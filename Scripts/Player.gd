extends CharacterBody2D

# Configuración calibrada para movimiento natural
const MOVE_SPEED = 120
const JUMP_FORCE = -280
const GRAVITY = 22
const MAX_HORIZONTAL_SPEED = 150
const ACCELERATION = 15
const FRICTION = 20

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var mobile_controls = $MobileControls

var lifes = 3
var is_jumping := false

func _ready():
	if mobile_controls:
		mobile_controls.jump_pressed.connect(_on_mobile_jump)

func _physics_process(delta):
	# 1. Aplicar gravedad
	if not is_on_floor():
		velocity.y += GRAVITY
	else:
		is_jumping = false
	
	# 2. Obtener dirección de movimiento
	var move_direction := Vector2.ZERO
	
	if mobile_controls and mobile_controls.is_dragging:
		# Suavizar la dirección del joystick
		move_direction.x = lerp(move_direction.x, mobile_controls.get_movement_vector().x, 0.3)
	else:
		move_direction.x = Input.get_axis("ui_left", "ui_right")
	
	# 3. Aplicar movimiento horizontal con aceleración
	if move_direction.x != 0:
		velocity.x = move_toward(velocity.x, move_direction.x * MOVE_SPEED, ACCELERATION)
	else:
		# Fricción cuando no hay input
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# 4. Manejar saltos
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up") or (mobile_controls and mobile_controls.jump_just_pressed):
			_perform_jump()
		if mobile_controls: 
				mobile_controls.jump_just_pressed = false
	else:
		# Reducir salto si se suelta el botón (salto corto)
		if (Input.is_action_just_released("ui_up") or (mobile_controls and mobile_controls.jump_just_released)) and velocity.y < JUMP_FORCE/2:
			velocity.y = JUMP_FORCE/2
			if mobile_controls: 
				mobile_controls.jump_just_released = false
	
	# 5. Manejar animaciones
	update_animations(move_direction)
	
	# 6. Mover el personaje (SOLO UNA VEZ)
	move_and_slide()

func _perform_jump():
	velocity.y = JUMP_FORCE
	is_jumping = true
	animationPlayer.play("Jump")

func update_animations(direction: Vector2):
	if not is_on_floor():
		animationPlayer.play("Jump")
	elif direction.x != 0:
		sprite.flip_h = direction.x > 0
		animationPlayer.play("Walk")
	else:
		animationPlayer.play("Idle")

func _on_mobile_jump():
	if is_on_floor():
		_perform_jump()

func add_Coin():
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	
	if canvasLayer:
		canvasLayer.handleCoinCollected()
	else:
		push_warning("CanvasLayer no encontrado para añadir moneda")

func _loseLife(enemyposx):
	# Aplicar knockback
	if position.x < enemyposx: 
		velocity.x = -200
		velocity.y = -100
	else: 
		velocity.x = 200
		velocity.y = -100
	
	move_and_slide()  # Aplicar el knockback inmediatamente
	
	lifes -= 1
	print("Perdiste una vida, Vida actual= " + str(lifes))
	
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	if canvasLayer:
		canvasLayer.handleHearts(lifes)
	
	if lifes <= 0:
		get_tree().reload_current_scene()

func _on_spikes_body_entered(body: Node2D) -> void:
	if body == self:
		print("Hemos pinchado")
		call_deferred("reiniciar_escena")

func reiniciar_escena():
	get_tree().change_scene_to_file("res://Sceness/Menu.tscn")
		
	
		
		
	
	





"""extends CharacterBody2D

#Configuracion de movimiento
const MOVE_SPEED = 250  # Velocidad base (unificada para todos los controles)
const JUMP_FORCE = -400
const GRAVITY = 15
const MAX_HORIZONTAL_SPEED = 200  # Límite de velocidad horizontal

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var mobile_controls = $MobileControls

var lifes = 3
var is_jumping := false

func _physics_process(_delta):
	
	
	var direction := Vector2.ZERO
	
	#Prioriza controles moviles si estan activos 
	if mobile_controls.is_dragging:
		direction = mobile_controls.get_movement_vector()
	else:
		# Mantén tus controles de teclado actuales para pruebas en PC
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
	velocity = direction * speed
	move_and_slide()
	
	velocity.y += gravity
	var friction = false

	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = true
		animationPlayer.play("Walk")
		velocity.x = min(velocity.x + moveSpeed, maxSpeed)

	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = false
		animationPlayer.play("Walk")
		velocity.x = max(velocity.x - moveSpeed, -maxSpeed)

	else:
		animationPlayer.play("Idle")
		friction = true

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			velocity.y = jumpHeight
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.5)
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0.0, 0.1)

	move_and_slide()
	
	
func add_Coin():
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	
	if not is_instance_valid(canvasLayer):
		print("ERROR: El nodo 'canvasLayer' no fue encontrado en el árbol de escena. Verifica su nombre y si está cargado correctamente.")
		return
	
	canvasLayer.handleCoinCollected()

func _loseLife(enemyposx):
	if position.x < enemyposx: 
		velocity.x = -200
		velocity.y = -100
		
	if position.x > enemyposx: 
		velocity.x =  200
		velocity.y = -100 
		
	lifes = lifes - 1
	
	print("Perdiste una vida, Vida actual= " + str(lifes))
	
	var canvasLayer = get_tree().get_root().find_child("CanvasLayer", true, false)
	
	canvasLayer.handleHearts(lifes)
		
	if lifes <= 0:
		get_tree().reload_current_scene()
	#	get_tree().change_scene_to_file("res://Sceness/Menu.tscn")

func _on_spikes_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		print("Hemos pinchado")
		call_deferred("reiniciar_escena")
	print(body.get_name())
		
func reiniciar_escena():
	get_tree().change_scene_to_file("res://Sceness/Menu.tscn")
"""
