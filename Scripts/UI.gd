extends CanvasLayer

var coins = 0
var heart1
var heart2
var heart3

@onready var CoinCollectedText = $CoinCollectedText

func _ready():
	
	
	heart1 = get_node("Heart1")
	heart2 = get_node("Heart2")
	heart3 = get_node("Heart3")
	
	if not is_instance_valid(CoinCollectedText):
		print("ERROR: El Label 'CoinCollectedText' no fue encontrado. Verifica su nombre y su ruta (actual: '$CoinCollectedText').")
		return
		
	CoinCollectedText.text = str(coins)
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		var controls = preload("res://UI/MobileControls.tscn").instantiate()
		# Añadir al root, no como hijo del CanvasLayer
		get_tree().root.add_child(controls)	

func handleCoinCollected():
	print("Moneda Recolectada!")
	coins += 1
	
	if is_instance_valid(CoinCollectedText):
		CoinCollectedText.text = str(coins)
	else:
		print("ADVERTENCIA: No se pudo actualizar el texto de monedas porque 'CoinCollectedText' es nulo en handleCoinCollected.")

	if coins == 10:
		call_deferred("Sigiente_nivel")
	print("Finalizo el nivel")
	
func handleHearts(lifes):
	
	if lifes == 0:
		heart1.visible = false
	
	if lifes == 1:
		heart2.visible = false
		
	if lifes == 2:
		heart3.visible = false
		
func Sigiente_nivel():
	#get_tree().change_scene_to_file("res://Sceness/Mundo2.tscn")
	get_tree().change_scene_to_file("res://Sceness/Mundo" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
