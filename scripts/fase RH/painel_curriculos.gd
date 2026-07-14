extends Control

var arrastando = false
var offset_mouse = Vector2.ZERO
var posicao_inicial = Vector2.ZERO

const LIMITE = 150

func _ready() -> void:
	posicao_inicial = position

func _process(delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() - offset_mouse
		var deslocamento = position.x - posicao_inicial.x
		rotation_degrees = deslocamento * 0.05
	
func _gui_input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:
				arrastando = true
				offset_mouse = get_global_mouse_position() - global_position

			else:
				arrastando = false
				verificar_destino()

func verificar_destino():

	var deslocamento = position.x - posicao_inicial.x

	if deslocamento > LIMITE:
		animar_aprovado()

	elif deslocamento < -LIMITE:
		animar_reprovado()

	else:
		var tween = create_tween()

		tween.parallel().tween_property(self, "position", posicao_inicial, 0.25)
		tween.parallel().tween_property(self, "rotation_degrees", 0, 0.25)
		
func animar_aprovado():

	var tween = create_tween()

	tween.parallel().tween_property(self, "position:x", 500, 0.3)
	tween.parallel().tween_property(self, "rotation_degrees", 20, 0.3)

	await tween.finished

	get_parent().verificar(true)
	
func animar_reprovado():

	var tween = create_tween()

	tween.parallel().tween_property(self, "position:x", -500, 0.3)
	tween.parallel().tween_property(self, "rotation_degrees", -20, 0.3)

	await tween.finished

	get_parent().verificar(false)
