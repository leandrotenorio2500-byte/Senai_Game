extends CanvasLayer

signal equipamento_selecionado(item: String)
signal atividade_finalizada(resultado: Dictionary)

@onready var btn_fechar: Button = $BtnFechar

@onready var btn_mouse: TextureButton = $Equipamentos/BtnMouse
@onready var btn_teclado: TextureButton = $Equipamentos/BtnTeclado
@onready var btn_monitor: TextureButton = $Equipamentos/BtnMonitor
@onready var btn_gabinete: TextureButton = $Equipamentos/BtnGabinete

var _bloqueado := false


func _ready() -> void:

	print("=== BANCADA ABERTA ===")

	var botoes: Array[TextureButton] = [
		btn_mouse,
		btn_teclado,
		btn_monitor,
		btn_gabinete
	]


	for botao in botoes:
		botao.focus_mode = Control.FOCUS_NONE


	btn_mouse.pressed.connect(func(): _selecionar("mouse_novo"))
	btn_teclado.pressed.connect(func(): _selecionar("teclado_novo"))
	btn_monitor.pressed.connect(func(): _selecionar("monitor_novo"))
	btn_gabinete.pressed.connect(func(): _selecionar("memoria_ram"))


	btn_fechar.pressed.connect(_fechar)

func mostrar_resultado(resultado: Dictionary) -> void:

	print("========================================")
	print("[ACTIVITY] Resultado da avaliação:")
	print(resultado)
	print("========================================")


	# --------------------------------------------------------
	# EQUIPAMENTO CORRETO
	# --------------------------------------------------------

	if resultado.get("correto", false):

		var precisa_substituicao: bool = resultado.get(
			"precisa_substituicao",
			false
		)


		if precisa_substituicao:

			print("[BANCADA] Defeito identificado!")

			print(
				"[BANCADA] Peça necessária: ",
				resultado.get("item_necessario", "")
			)

		else:

			print(
				"[BANCADA] Problema identificado, ",
				"mas não é necessária substituição."
			)


		# Bloqueia novas seleções.
		_bloqueado = true


		# Envia o resultado para o ActivityManager
		# e encerra a atividade.
		atividade_finalizada.emit({
			"cancelado": false,
			"correto": true,
			"setor": resultado.get("setor", ""),
			"precisa_substituicao": precisa_substituicao,
			"item_necessario": resultado.get(
				"item_necessario",
				""
			),
			"problema": resultado.get(
				"problema",
				""
			)
		})

		return


	# --------------------------------------------------------
	# EQUIPAMENTO INCORRETO
	# --------------------------------------------------------

	print("[BANCADA] Equipamento incorreto.")


func _selecionar(item: String) -> void:

	if _bloqueado:
		return

	_bloqueado = true

	print("Equipamento selecionado:", item)

	equipamento_selecionado.emit(item)


	await get_tree().create_timer(0.3).timeout

	_bloqueado = false



func liberar() -> void:

	_bloqueado = false



func _fechar() -> void:

	if _bloqueado:
		return

	var resultado := {
		"cancelado": true
	}

	atividade_finalizada.emit(resultado)



func fechar() -> void:

	queue_free()



func concluir(resultado: Dictionary) -> void:

	atividade_finalizada.emit(resultado)
