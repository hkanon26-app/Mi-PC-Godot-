extends CanvasLayer

@onready var leth_button = $CanvasLayer/ControlsContainer/LeftButton
@onready var right_button = $CanvasLayer/ControlsContainer/RightButton
@onready var jump_button = $CanvasLayer/ControlsContainer/JumpButton

func _ready() -> void:
	#Solo mostrar controles en dispositivos moviles 
	if OS.has_feature("mobile") or OS.has_feature("web_mobile"):
		visible = true 
	else:
		visible = false

func _on_left_button_pressed():
	Input.action_press("ui_left")
func _on_left_button_released():
	Input.action_release("ui_left")

func _on_right_button_pressed():
	Input.action_press("ui_right")
func _on_right_button_releassed():
	Input.action_release("ui_right")
	
func _on_jump_button_pressed():
	Input.action_press("ui_up")
func _on_jump_button_releassed():
	Input.action_release("ui_up")
