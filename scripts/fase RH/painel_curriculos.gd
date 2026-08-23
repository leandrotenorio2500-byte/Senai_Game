extends Control
class_name PainelCurriculo

signal decisao_finalizada(aprovado: bool)

@export var limite_decisao := 150
@export var velocidade_teclado := 900.0

@onready var border: ColorRect = $border

var arrastando := false
var usando_teclado := false
var bloqueado := false

var offset_mouse := Vector2.ZERO
var posicao_inicial := Vector2.ZERO


func _ready():
	posicao_inicial = global_position


func _process(delta):

	if bloqueado:
		return

	# ============================================================
	# MOVIMENTO DO CURRÍCULO
	# ============================================================

	if arrastando:
		# Movimento exclusivamente pelo mouse
		global_position = get_global_mouse_position() - offset_mouse

	else:
		# Movimento pelas setas
		movimento_teclado(delta)

	# ============================================================
	# VISUAL
	# ============================================================

	atualizar_visual()

	# ============================================================
	# DECISÃO AUTOMÁTICA
	# ============================================================

	# IMPORTANTE:
	# O mouse NÃO verifica o limite aqui.
	# A decisão pelo mouse acontece somente quando o jogador solta.
	if not arrastando:
		verificar_limite_teclado()


# ============================================================
# TECLADO
# ============================================================

func movimento_teclado(delta):

	var eixo = Input.get_axis("ui_left", "ui_right")

	if eixo != 0:
		usando_teclado = true

		global_position.x += eixo * velocidade_teclado * delta

	elif usando_teclado:
		usando_teclado = false
		voltar_ao_inicio()


func verificar_limite_teclado():

	var deslocamento = global_position.x - posicao_inicial.x

	if deslocamento >= limite_decisao:
		aprovar()

	elif deslocamento <= -limite_decisao:
		reprovar()


# ============================================================
# VISUAL
# ============================================================

func atualizar_visual():

	var deslocamento = global_position.x - posicao_inicial.x

	rotation_degrees = deslocamento * 0.05

	var intensidade = clamp(
		abs(deslocamento) / limite_decisao,
		0.0,
		1.0
	)

	if deslocamento > 0:

		border.color = Color.WHITE.lerp(
			Color.GREEN,
			intensidade
		)

	elif deslocamento < 0:

		border.color = Color(1, 1, 1, 0).lerp(
			Color.RED,
			intensidade
		)

	else:

		border.color = Color(1, 1, 1, 0)


# ============================================================
# MOUSE
# ============================================================

func _gui_input(event):

	# Se o currículo já foi processado, ignora qualquer evento.
	if bloqueado:
		return

	if usando_teclado:
		return

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				arrastando = true

				offset_mouse = (
					get_global_mouse_position()
					- global_position
				)

			else:

				arrastando = false

				# A decisão pelo mouse acontece SOMENTE aqui.
				avaliar_mouse()


func avaliar_mouse():

	# Segurança extra.
	if bloqueado:
		return

	var distancia = global_position.x - posicao_inicial.x

	if distancia >= limite_decisao:

		aprovar()

	elif distancia <= -limite_decisao:

		reprovar()

	else:

		voltar_ao_inicio()


# ============================================================
# APROVAR
# ============================================================

func aprovar():

	# Impede que a decisão seja executada duas vezes.
	if bloqueado:
		return

	bloqueado = true
	arrastando = false
	usando_teclado = false

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"global_position:x",
		posicao_inicial.x + 500,
		0.2
	)

	tween.parallel().tween_property(
		self,
		"rotation_degrees",
		20,
		0.2
	)

	await tween.finished

	decisao_finalizada.emit(true)


# ============================================================
# REPROVAR
# ============================================================

func reprovar():

	# Impede que a decisão seja executada duas vezes.
	if bloqueado:
		return

	bloqueado = true
	arrastando = false
	usando_teclado = false

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"global_position:x",
		posicao_inicial.x - 500,
		0.2
	)

	tween.parallel().tween_property(
		self,
		"rotation_degrees",
		-20,
		0.2
	)

	await tween.finished

	decisao_finalizada.emit(false)


# ============================================================
# VOLTAR PARA O CENTRO
# ============================================================

func voltar_ao_inicio():

	if bloqueado:
		return

	var tween = create_tween()

	tween.parallel().tween_property(
		self,
		"global_position",
		posicao_inicial,
		0.25
	)

	tween.parallel().tween_property(
		self,
		"rotation_degrees",
		0,
		0.25
	)


# ============================================================
# RESET
# ============================================================

func resetar():

	bloqueado = false
	arrastando = false
	usando_teclado = false

	global_position = posicao_inicial

	rotation_degrees = 0

	border.modulate = Color.WHITE
