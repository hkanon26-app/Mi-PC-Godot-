extends CharacterBody2D

const moveSpeed = 25
const maxSpeed = 50
const jumpHeight = -300
const gravity = 15

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer

#var motion = Vector2()
var lifes = 3

func _physics_process(_delta):
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
