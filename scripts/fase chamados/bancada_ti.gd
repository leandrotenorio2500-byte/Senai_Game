extends Control

signal atividade_finalizada(resultado: Dictionary)

@onready var tutorial: Control = $Tutorial
@onready var introducao: Control = $Introducao


# ============================================================
# PAINEL DO CHAMADO
# ============================================================

@onready var painel_chamado: Control = $PainelChamado

@onready var label_titulo: Label = $PainelChamado/Chamado/LabelTitulo
@onready var label_funcionario: Label = $PainelChamado/Queixa/LabelFuncionario
@onready var label_problema: Label = $PainelChamado/Queixa/LabelProblema
@onready var label_objetivo: Label = $PainelChamado/Chamado/LabelObjetivo
@onready var npc: TextureRect = $PainelChamado/Queixa/NPC


# ============================================================
# PAINEL DE INTERAÇÃO
# ============================================================

@onready var painel_interacao: Control = $PainelInteracao

@onready var btn_interacao_1: Button = $PainelInteracao/NinePatchRect/opcao1
@onready var btn_interacao_2: Button = $PainelInteracao/NinePatchRect/opcao2
@onready var btn_interacao_3: Button = $PainelInteracao/NinePatchRect/opcao3
@onready var fechar: Button = $PainelInteracao/NinePatchRect/fechar

@onready var label_feedback: Label = $PainelInteracao/NinePatchRect/LabelFeedback
@onready var timer_feedback: Timer = $PainelInteracao/TimerFeedback


# ============================================================
# NOME DO OBJETO
# ============================================================

@onready var nome_objeto: Label = $NomeObjeto


# ============================================================
# EQUIPAMENTOS
# ============================================================

@onready var btn_monitor: TextureButton = $Equipamentos/BtnMonitor
@onready var btn_gabinete: TextureButton = $Equipamentos/BtnGabinete
@onready var btn_teclado: TextureButton = $Equipamentos/BtnTeclado
@onready var btn_mouse: TextureButton = $Equipamentos/BtnMouse
@onready var btn_impressora: TextureButton = $Equipamentos/BtnImpressora


# ============================================================
# TEXTURAS
# ============================================================

@export var mouse_novo_texture: Texture2D
@onready var background: TextureRect = $BackGround


# ============================================================
# ESTADOS
# ============================================================

enum Etapa {
	INVESTIGACAO,
	ACAO,
	FINALIZADO
}

var etapa_atual: Etapa = Etapa.INVESTIGACAO


# ============================================================
# ESTADO DO PROCEDIMENTO
# ============================================================

var executando_procedimento := false


# ============================================================
# CHAMADO ATUAL
# ============================================================

var chamado_atual: Dictionary = {}
var indice_chamado_atual := 0


# ============================================================
# CHAMADOS
# ============================================================

var chamados := [

	{
		"id": "chamado_01",
		"setor": "Recepção",
		"funcionario": "Ana - Recepção",
		"problema": "mouse_com_defeito",
		"descricao": "Não estou mais conseguindo clicar em nada! O cursor não sai do lugar.",
		"equipamento": "mouse",
		"acao": "substituir_mouse",
		"visual": {
			"background": preload("res://sprites/missions/chamados/MesaRecepcao.png"),
			"mouse": null,
			"monitor": null,
			"gabinete": null,
			"teclado": null,
			"impressora": null,
			"npc": preload("res://sprites/Mini UI/heads/Ana.png")
		}
	},

	{
		"id": "chamado_02",
		"setor": "RH",
		"funcionario": "Vitória - RH",
		"problema": "sem_imagem",
		"descricao": "O computador liga, mas o monitor não apresenta imagem.",
		"equipamento": "monitor",
		"acao": "verificar_cabo",
		"visual": {
			"background": preload("res://sprites/missions/chamados/MesaRecepcao.png"),
			"mouse": null,
			"monitor": null,
			"gabinete": null,
			"teclado": null,
			"impressora": null,
			"npc": preload("res://sprites/Mini UI/heads/Vitoria.png")
		}
	},

	{
		"id": "chamado_03",
		"setor": "Produção",
		"funcionario": "Thiago - Produção",
		"problema": "computador_lento",
		"descricao": "O computador está muito lento durante o uso.",
		"equipamento": "gabinete",
		"acao": "verificar_software",
		"visual": {
			"background": preload("res://sprites/missions/chamados/MesaRecepcao.png"),
			"mouse": null,
			"monitor": null,
			"gabinete": null,
			"teclado": null,
			"impressora": null,
			"npc": preload("res://sprites/Mini UI/heads/Jobson.png")
		}
	},

	{
		"id": "chamado_04",
		"setor": "Diretoria",
		"funcionario": "Michele - Diretoria",
		"problema": "impressora",
		"descricao": "A impressora não está realizando as impressões.",
		"equipamento": "impressora",
		"acao": "verificar_impressao",
		"visual": {
			"background": preload("res://sprites/missions/chamados/MesaRecepcao.png"),
			"mouse": null,
			"monitor": null,
			"gabinete": null,
			"teclado": null,
			"impressora": null,
			"npc": preload("res://sprites/Mini UI/heads/Michele.png")
		}
	}
]

# ============================================================
# TEXTURAS ORIGINAIS DOS EQUIPAMENTOS
# ============================================================

var mouse_texture_original: Texture2D
var monitor_texture_original: Texture2D
var gabinete_texture_original: Texture2D
var teclado_texture_original: Texture2D
var impressora_texture_original: Texture2D
var background_texture_original: Texture2D

# ============================================================
# INICIALIZAÇÃO
# ============================================================

func _ready() -> void:

	introducao.visible = true
	tutorial.visible = false
	# --------------------------------------------------------
	# EQUIPAMENTOS
	# --------------------------------------------------------

	btn_monitor.pressed.connect(
		func(): _interagir("monitor")
	)

	btn_gabinete.pressed.connect(
		func(): _interagir("gabinete")
	)

	btn_teclado.pressed.connect(
		func(): _interagir("teclado")
	)

	btn_mouse.pressed.connect(
		func(): _interagir("mouse")
	)

	btn_impressora.pressed.connect(
		func(): _interagir("impressora")
	)


	# --------------------------------------------------------
	# HOVER DOS EQUIPAMENTOS
	# --------------------------------------------------------

	btn_monitor.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Monitor", btn_monitor)
	)

	btn_monitor.mouse_exited.connect(
		_esconder_nome_objeto
	)

	btn_gabinete.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Gabinete", btn_gabinete)
	)

	btn_teclado.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Teclado", btn_teclado)
	)

	btn_mouse.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Mouse", btn_mouse)
	)

	btn_impressora.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Impressora", btn_impressora)
	)

	btn_monitor.mouse_exited.connect(
		_esconder_nome_objeto
	)

	btn_gabinete.mouse_exited.connect(
		_esconder_nome_objeto
	)

	btn_teclado.mouse_exited.connect(
		_esconder_nome_objeto
	)

	btn_mouse.mouse_exited.connect(
		_esconder_nome_objeto
	)

	btn_impressora.mouse_exited.connect(
		_esconder_nome_objeto
	)

	# --------------------------------------------------------
	# GUARDAR TEXTURAS ORIGINAIS
	# --------------------------------------------------------

	mouse_texture_original = btn_mouse.texture_normal
	monitor_texture_original = btn_monitor.texture_normal
	gabinete_texture_original = btn_gabinete.texture_normal
	teclado_texture_original = btn_teclado.texture_normal
	impressora_texture_original = btn_impressora.texture_normal

	# --------------------------------------------------------
	# ESTADO INICIAL
	# --------------------------------------------------------

	nome_objeto.visible = false

	painel_interacao.visible = false

	label_feedback.visible = false

	timer_feedback.timeout.connect(
		_encerrar_feedback
	)

	fechar.pressed.connect(
		_fechar_painel_interacao
	)


	# --------------------------------------------------------
	# CARREGAR PRIMEIRO CHAMADO
	# --------------------------------------------------------





# ============================================================
# CARREGAR CHAMADO
# ============================================================

func carregar_chamado(indice: int) -> void:

	if indice < 0 or indice >= chamados.size():

		print("[TI] Índice de chamado inválido.")
		return

	indice_chamado_atual = indice

	chamado_atual = chamados[indice].duplicate()

	etapa_atual = Etapa.INVESTIGACAO
	executando_procedimento = false

	# Limpar interação anterior
	painel_interacao.visible = false
	label_feedback.visible = false
	timer_feedback.stop()

	# Restaurar botões
	btn_mouse.disabled = false
	btn_monitor.disabled = false
	btn_gabinete.disabled = false
	btn_teclado.disabled = false
	btn_impressora.disabled = false

	_resetar_aparencia_equipamentos()
	_aplicar_visual_chamado()

	print("========================================")
	print("[TI] CHAMADO CARREGADO")
	print("[TI] ID: ", chamado_atual["id"])
	print("[TI] Funcionário: ", chamado_atual["funcionario"])
	print("[TI] Setor: ", chamado_atual["setor"])
	print("[TI] Problema: ", chamado_atual["problema"])
	print("========================================")

	atualizar_painel()

func _resetar_aparencia_equipamentos() -> void:

	# --------------------------------------------------------
	# MOUSE
	# --------------------------------------------------------

	btn_mouse.texture_normal = mouse_texture_original
	btn_mouse.texture_hover = mouse_texture_original
	btn_mouse.texture_pressed = mouse_texture_original


	# --------------------------------------------------------
	# OUTROS EQUIPAMENTOS
	# --------------------------------------------------------

	btn_monitor.texture_normal = monitor_texture_original
	btn_monitor.texture_hover = monitor_texture_original
	btn_monitor.texture_pressed = monitor_texture_original

	btn_gabinete.texture_normal = gabinete_texture_original
	btn_gabinete.texture_hover = gabinete_texture_original
	btn_gabinete.texture_pressed = gabinete_texture_original

	btn_teclado.texture_normal = teclado_texture_original
	btn_teclado.texture_hover = teclado_texture_original
	btn_teclado.texture_pressed = teclado_texture_original

	btn_impressora.texture_normal = impressora_texture_original
	btn_impressora.texture_hover = impressora_texture_original
	btn_impressora.texture_pressed = impressora_texture_original


	# --------------------------------------------------------
	# HABILITAR EQUIPAMENTOS
	# --------------------------------------------------------

	btn_mouse.disabled = false
	btn_monitor.disabled = false
	btn_gabinete.disabled = false
	btn_teclado.disabled = false
	btn_impressora.disabled = false

func _aplicar_visual_chamado() -> void:

	var visual: Dictionary = chamado_atual.get("visual", {})

	# --------------------------------------------------------
	# BACKGROUND
	# --------------------------------------------------------

	var background_texture = visual.get("background")

	if background_texture != null:

		background.texture = background_texture

	else:

		background.texture = background_texture_original


	# --------------------------------------------------------
	# MOUSE
	# --------------------------------------------------------

	var mouse_texture = visual.get("mouse")

	if mouse_texture != null:

		btn_mouse.texture_normal = mouse_texture
		btn_mouse.texture_hover = mouse_texture
		btn_mouse.texture_pressed = mouse_texture


	# --------------------------------------------------------
	# MONITOR
	# --------------------------------------------------------

	var monitor_texture = visual.get("monitor")

	if monitor_texture != null:

		btn_monitor.texture_normal = monitor_texture
		btn_monitor.texture_hover = monitor_texture
		btn_monitor.texture_pressed = monitor_texture


	# --------------------------------------------------------
	# GABINETE
	# --------------------------------------------------------

	var gabinete_texture = visual.get("gabinete")

	if gabinete_texture != null:

		btn_gabinete.texture_normal = gabinete_texture
		btn_gabinete.texture_hover = gabinete_texture
		btn_gabinete.texture_pressed = gabinete_texture


	# --------------------------------------------------------
	# TECLADO
	# --------------------------------------------------------

	var teclado_texture = visual.get("teclado")

	if teclado_texture != null:

		btn_teclado.texture_normal = teclado_texture
		btn_teclado.texture_hover = teclado_texture
		btn_teclado.texture_pressed = teclado_texture


	# --------------------------------------------------------
	# IMPRESSORA
	# --------------------------------------------------------

	var impressora_texture = visual.get("impressora")

	if impressora_texture != null:

		btn_impressora.texture_normal = impressora_texture
		btn_impressora.texture_hover = impressora_texture
		btn_impressora.texture_pressed = impressora_texture
		
	# ========================================================
	# NPC
	# ========================================================

	var npc_texture = visual.get("npc")

	if npc_texture != null:

		npc.texture = npc_texture

func _interagir(objeto: String) -> void:

	if executando_procedimento:
		return

	print("[TI] Objeto clicado: ", objeto)

	if label_feedback.visible:
		_encerrar_feedback()

	_configurar_painel_interacao(objeto)


# ============================================================
# CONFIGURAR PAINEL DE INTERAÇÃO
# ============================================================

func _configurar_painel_interacao(objeto: String) -> void:

	if executando_procedimento:
		return

	painel_interacao.visible = true

	label_feedback.visible = false

	btn_interacao_1.visible = true
	btn_interacao_2.visible = true
	btn_interacao_3.visible = true
	fechar.visible = true

	match objeto:

		"mouse":

			btn_interacao_1.text = "Testar mouse"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Verificar bateria"

			_conectar_opcoes_mouse()


		"monitor":

			btn_interacao_1.text = "Testar monitor"
			btn_interacao_2.text = "Verificar energia"
			btn_interacao_3.text = "Trocar monitor"

			_conectar_opcoes_monitor()


		"gabinete":

			btn_interacao_1.text = "Ligar computador"
			btn_interacao_2.text = "Verificar componentes"
			btn_interacao_3.text = "Verificar software"

			_conectar_opcoes_gabinete()


		"teclado":

			btn_interacao_1.text = "Testar teclado"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Trocar teclado"

			_conectar_opcoes_teclado()


		"impressora":

			btn_interacao_1.text = "Testar impressão"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Verificar papel"

			_conectar_opcoes_impressora()


		_:

			painel_interacao.visible = false


# ============================================================
# OPÇÕES DO MOUSE
# ============================================================

func _conectar_opcoes_mouse() -> void:

	_desconectar_botoes()

	btn_interacao_1.pressed.connect(
		func(): _acao_mouse("testar")
	)

	btn_interacao_2.pressed.connect(
		func(): _acao_mouse("conexao")
	)

	btn_interacao_3.pressed.connect(
		func(): _acao_mouse("bateria")
	)


func _acao_mouse(acao: String) -> void:

	if executando_procedimento:
		return

	match acao:

		"testar":

			if chamado_atual.get("equipamento") == "mouse":

				if etapa_atual == Etapa.INVESTIGACAO:

					etapa_atual = Etapa.ACAO

					# O botão muda de função
					btn_interacao_1.text = "Substituir mouse"

					atualizar_painel()

					_mostrar_feedback(
						"O cursor apresenta falhas durante o uso."
					)

				elif etapa_atual == Etapa.ACAO:

					_iniciar_substituicao_mouse()

			else:

				_mostrar_feedback(
					"O mouse parece estar funcionando normalmente."
				)


		"conexao":

			_mostrar_feedback(
				"A conexão do mouse parece estar correta."
			)


		"bateria":

			_mostrar_feedback(
				"O problema não parece ser na bateria do mouse."
			)

# ============================================================
# INICIAR SUBSTITUIÇÃO DO MOUSE
# ============================================================

func _iniciar_substituicao_mouse() -> void:

	if executando_procedimento:
		return

	executando_procedimento = true

	print("[TI] Iniciando substituição do mouse.")

	# Impede novas interações durante o procedimento.

	btn_mouse.disabled = true

	painel_interacao.visible = true

	btn_interacao_1.visible = false
	btn_interacao_2.visible = false
	btn_interacao_3.visible = false
	fechar.visible = false

	_executar_substituicao_mouse()


# ============================================================
# PROCEDIMENTO DE SUBSTITUIÇÃO
# ============================================================

func _executar_substituicao_mouse() -> void:

	# --------------------------------------------------------
	# ETAPA 1 — REMOVER
	# --------------------------------------------------------

	label_feedback.text = "Removendo o mouse antigo..."
	label_feedback.visible = true

	print("[TI] Removendo mouse antigo...")

	await get_tree().create_timer(0.8).timeout


	# --------------------------------------------------------
	# ETAPA 2 — INSTALAR
	# --------------------------------------------------------

	label_feedback.text = "Instalando o mouse novo..."

	print("[TI] Instalando mouse novo...")

	await get_tree().create_timer(0.8).timeout


	if mouse_novo_texture:

		btn_mouse.texture_normal = mouse_novo_texture
		btn_mouse.texture_hover = mouse_novo_texture
		btn_mouse.texture_pressed = mouse_novo_texture


	# --------------------------------------------------------
	# ETAPA 3 — TESTAR
	# --------------------------------------------------------

	label_feedback.text = "Testando o novo mouse..."

	print("[TI] Testando mouse...")

	await get_tree().create_timer(1.0).timeout


	# --------------------------------------------------------
	# ETAPA 4 — CONFIRMAÇÃO
	# --------------------------------------------------------

	label_feedback.text = "O mouse novo está funcionando corretamente."

	print("[TI] Mouse funcionando corretamente!")

	await get_tree().create_timer(1.5).timeout


	# --------------------------------------------------------
	# FINALIZA
	# --------------------------------------------------------

	btn_mouse.disabled = false

	executando_procedimento = false

	_finalizar_chamado()


# ============================================================
# OPÇÕES DO MONITOR
# ============================================================

func _conectar_opcoes_monitor() -> void:

	_desconectar_botoes()

	btn_interacao_1.pressed.connect(
		func(): _acao_monitor("testar")
	)

	btn_interacao_2.pressed.connect(
		func(): _acao_monitor("energia")
	)

	btn_interacao_3.pressed.connect(
		func(): _acao_monitor("trocar")
	)


func _acao_monitor(acao: String) -> void:

	if executando_procedimento:
		return

	match acao:

		"testar":

			if etapa_atual == Etapa.INVESTIGACAO:

				if chamado_atual.get("equipamento") == "monitor":

					etapa_atual = Etapa.ACAO

					# O botão muda de função
					btn_interacao_1.text = "Verificar cabo VGA"

					atualizar_painel()

					_mostrar_feedback(
						"O monitor está ligado, mas não apresenta imagem."
					)

				else:

					_mostrar_feedback(
						"O monitor parece estar funcionando normalmente."
					)

			elif etapa_atual == Etapa.ACAO:

				_iniciar_verificacao_monitor()


		"energia":

			_mostrar_feedback(
				"O monitor está recebendo energia normalmente."
			)


		"trocar":

			_mostrar_feedback(
				"Vamos verificar as outras opções antes de trocar o monitor."
			)


# ============================================================
# INICIAR VERIFICAÇÃO DO MONITOR
# ============================================================

func _iniciar_verificacao_monitor() -> void:

	if executando_procedimento:
		return

	executando_procedimento = true

	print("[TI] Iniciando verificação do monitor.")

	# Impede novas interações durante o procedimento.

	btn_monitor.disabled = true

	painel_interacao.visible = true

	btn_interacao_1.visible = false
	btn_interacao_2.visible = false
	btn_interacao_3.visible = false
	fechar.visible = false

	_executar_verificacao_monitor()
	
# ============================================================
# PROCEDIMENTO DE VERIFICAÇÃO DO MONITOR
# ============================================================

func _executar_verificacao_monitor() -> void:

	# --------------------------------------------------------
	# ETAPA 1 — VERIFICAR CABO
	# --------------------------------------------------------

	label_feedback.text = "Verificando conexão do monitor..."
	label_feedback.visible = true

	print("[TI] Verificando conexão do monitor...")

	await get_tree().create_timer(0.8).timeout


	# --------------------------------------------------------
	# ETAPA 2 — IDENTIFICAR PROBLEMA
	# --------------------------------------------------------

	label_feedback.text = "O cabo de vídeo está desconectado."

	print("[TI] Cabo de vídeo desconectado.")

	await get_tree().create_timer(1.0).timeout


	# --------------------------------------------------------
	# ETAPA 3 — RECONECTAR
	# --------------------------------------------------------

	label_feedback.text = "Reconectando o cabo de vídeo..."

	print("[TI] Reconectando cabo de vídeo...")

	await get_tree().create_timer(1.0).timeout


	# --------------------------------------------------------
	# ETAPA 4 — TESTAR SINAL
	# --------------------------------------------------------

	label_feedback.text = "Testando sinal de vídeo..."

	print("[TI] Testando sinal de vídeo...")

	await get_tree().create_timer(1.0).timeout


	# --------------------------------------------------------
	# ETAPA 5 — CONFIRMAÇÃO
	# --------------------------------------------------------

	label_feedback.text = "O monitor voltou a apresentar imagem."

	print("[TI] Monitor funcionando corretamente!")

	await get_tree().create_timer(1.5).timeout


	# --------------------------------------------------------
	# FINALIZA
	# --------------------------------------------------------

	btn_monitor.disabled = false

	executando_procedimento = false

	_finalizar_chamado()

# ============================================================
# OPÇÕES DO GABINETE
# ============================================================

func _conectar_opcoes_gabinete() -> void:

	_desconectar_botoes()

	btn_interacao_1.pressed.connect(
		func(): _acao_gabinete("ligar")
	)

	btn_interacao_2.pressed.connect(
		func(): _acao_gabinete("componentes")
	)

	btn_interacao_3.pressed.connect(
		func(): _acao_gabinete("software")
	)


func _acao_gabinete(acao: String) -> void:

	if executando_procedimento:
		return

	match acao:

		"ligar":

			_mostrar_feedback(
				"O computador está ligado."
			)


		"componentes":

			_mostrar_feedback(
				"Os componentes parecem estar conectados corretamente."
			)


		"software":

			if chamado_atual.get("equipamento") == "gabinete":

				etapa_atual = Etapa.ACAO
				atualizar_painel()

				_abrir_ambiente_software()

			else:

				_mostrar_feedback(
					"Não encontrei nenhum problema aparente."
				)


# ============================================================
# OPÇÕES DO TECLADO
# ============================================================

func _conectar_opcoes_teclado() -> void:

	_desconectar_botoes()

	btn_interacao_1.pressed.connect(
		func(): _acao_teclado("testar")
	)

	btn_interacao_2.pressed.connect(
		func(): _acao_teclado("conexao")
	)

	btn_interacao_3.pressed.connect(
		func(): _acao_teclado("trocar")
	)


func _acao_teclado(acao: String) -> void:

	if executando_procedimento:
		return

	match acao:

		"testar":

			_mostrar_feedback(
				"O teclado está respondendo corretamente."
			)


		"conexao":

			_mostrar_feedback(
				"A conexão do teclado parece estar correta."
			)


		"trocar":

			_mostrar_feedback(
				"Não há necessidade de trocar o teclado."
			)


# ============================================================
# OPÇÕES DA IMPRESSORA
# ============================================================

func _conectar_opcoes_impressora() -> void:

	_desconectar_botoes()

	btn_interacao_1.pressed.connect(
		func(): _acao_impressora("testar")
	)

	btn_interacao_2.pressed.connect(
		func(): _acao_impressora("conexao")
	)

	btn_interacao_3.pressed.connect(
		func(): _acao_impressora("papel")
	)


func _acao_impressora(acao: String) -> void:

	if executando_procedimento:
		return

	match acao:

		"testar":

			if chamado_atual.get("equipamento") == "impressora":

				if etapa_atual == Etapa.INVESTIGACAO:

					etapa_atual = Etapa.ACAO

					# Muda a função percebida pelo jogador
					btn_interacao_1.text = "Verificar fila de impressão"

					atualizar_painel()

					_mostrar_feedback(
						"A impressora não está realizando a impressão."
					)

				elif etapa_atual == Etapa.ACAO:

					_abrir_janela_fila()

			else:

				_mostrar_feedback(
					"A impressora está funcionando normalmente."
				)


		"papel":

			_mostrar_feedback(
				"Há papel disponível na impressora."
			)
			
		"conexao":

			_mostrar_feedback(
				"A conexão da impressora parece estar em ordem."
			)

func _abrir_janela_fila() -> void:

	if executando_procedimento:
		return

	executando_procedimento = true

	print("========================================")
	print("[TI] ABRINDO FILA DE IMPRESSÃO")
	print("========================================")

	painel_interacao.visible = false
	nome_objeto.visible = false

	var cena = preload(
		"res://scene/fase chamados/ambiente_fila_impressao.tscn"
		
	)

	var instancia = cena.instantiate()

	if instancia.has_signal("atividade_finalizada"):

		instancia.atividade_finalizada.connect(
			_janela_fila_finalizada
		)

		print(
			"[TI] Sinal atividade_finalizada da fila conectado."
		)

	else:

		push_error(
			"[TI] ERRO: JanelaFila não possui o sinal atividade_finalizada."
		)

	add_child(instancia)
	
func _janela_fila_finalizada(resultado: Dictionary) -> void:

	print("========================================")
	print("[TI] RECEBI RESULTADO DA FILA DE IMPRESSÃO")
	print("[TI] Resultado: ", resultado)
	print("========================================")

	executando_procedimento = false

	if resultado.get("resolvido", false):

		print("[TI] FILA DE IMPRESSÃO RESOLVIDA!")

		_finalizar_chamado()

	else:

		print("[TI] A FILA DE IMPRESSÃO NÃO FOI RESOLVIDA.")

# ============================================================
# DESCONECTAR BOTÕES
# ============================================================

func _desconectar_botoes() -> void:

	for conexao in btn_interacao_1.pressed.get_connections():

		btn_interacao_1.pressed.disconnect(
			conexao["callable"]
		)


	for conexao in btn_interacao_2.pressed.get_connections():

		btn_interacao_2.pressed.disconnect(
			conexao["callable"]
		)


	for conexao in btn_interacao_3.pressed.get_connections():

		btn_interacao_3.pressed.disconnect(
			conexao["callable"]
		)


# ============================================================
# FEEDBACK
# ============================================================

func _mostrar_feedback(
	texto: String,
	duracao: float = 2.5
) -> void:

	if executando_procedimento:
		label_feedback.text = texto
		label_feedback.visible = true
		return

	label_feedback.text = texto
	label_feedback.visible = true

	btn_interacao_1.visible = false
	btn_interacao_2.visible = false
	btn_interacao_3.visible = false
	fechar.visible = false

	timer_feedback.stop()

	timer_feedback.wait_time = duracao
	timer_feedback.start()


# ============================================================
# ENCERRAR FEEDBACK
# ============================================================

func _encerrar_feedback() -> void:

	if executando_procedimento:
		return

	label_feedback.visible = false

	timer_feedback.stop()

	btn_interacao_1.visible = true
	btn_interacao_2.visible = true
	btn_interacao_3.visible = true
	fechar.visible = true


# ============================================================
# FECHAR PAINEL DE INTERAÇÃO
# ============================================================

func _fechar_painel_interacao() -> void:

	if executando_procedimento:
		return

	painel_interacao.visible = false

	label_feedback.visible = false

	timer_feedback.stop()


# ============================================================
# CLIQUE FORA DO PAINEL
# ============================================================

func _input(event: InputEvent) -> void:

	if not painel_interacao.visible:
		return

	if not label_feedback.visible:
		return

	if executando_procedimento:
		return

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				var posicao_mouse: Vector2 = get_global_mouse_position()

				if not painel_interacao.get_global_rect().has_point(
					posicao_mouse
				):

					_encerrar_feedback()


# ============================================================
# NOME DO OBJETO
# ============================================================

func _mostrar_nome_objeto(nome: String, objeto: Control) -> void:

	nome_objeto.text = nome

	# Pega o centro do objeto
	var centro := objeto.position + (objeto.size / 2.0)

	# Centraliza a Label horizontalmente sobre o objeto
	nome_objeto.position.x = centro.x - (nome_objeto.size.x / 2.0)

	# Coloca a Label acima do objeto
	nome_objeto.position.y = objeto.position.y - nome_objeto.size.y - 2

	nome_objeto.visible = true


func _esconder_nome_objeto() -> void:

	nome_objeto.visible = false


# ============================================================
# DESCRIÇÃO DA AÇÃO
# ============================================================

func _descricao_acao() -> String:

	match chamado_atual.get("acao", ""):

		"substituir_mouse":
			return "Substitua o mouse."

		"verificar_cabo":
			return "Verifique a conexão do monitor."

		"verificar_software":
			return "Verifique o computador."

		"verificar_impressao":
			return "Verifique a impressora."

		_:
			return "Realize o procedimento necessário."


# ============================================================
# ATUALIZAR PAINEL DO CHAMADO
# ============================================================

func atualizar_painel() -> void:

	if chamado_atual.is_empty():

		painel_chamado.visible = false

		return

	painel_chamado.visible = true

	label_titulo.text = "CHAMADO"

	label_funcionario.text = (
		str(chamado_atual.get("funcionario", ""))
	)

	label_problema.text = (
		str(chamado_atual.get("descricao", ""))
	)
	

	match etapa_atual:

		Etapa.INVESTIGACAO:

			label_objetivo.text = (
				"Objetivo:" +
				" Identifique o equipamento com problema."
			)


		Etapa.ACAO:

			label_objetivo.text = (
				"Problema identificado!\n" +
				"Ação:\n" +
				_descricao_acao()
			)


		Etapa.FINALIZADO:

			label_objetivo.text = (
				"✓ Chamado resolvido!"
			)


# ============================================================
# FINALIZAR CHAMADO
# ============================================================

func _finalizar_chamado() -> void:

	print("[TI] Entrando em _finalizar_chamado()")

	etapa_atual = Etapa.FINALIZADO
	executando_procedimento = false

	painel_interacao.visible = false
	label_feedback.visible = false

	timer_feedback.stop()

	atualizar_painel()

	print("========================================")
	print("[TI] CHAMADO RESOLVIDO!")
	print("[TI] Funcionário: ", chamado_atual["funcionario"])
	print("[TI] Setor: ", chamado_atual["setor"])
	print("========================================")

	await get_tree().create_timer(1.0).timeout

	_proximo_chamado()
	
# ============================================================
# PRÓXIMO CHAMADO
# ============================================================

func _proximo_chamado() -> void:

	var proximo_indice := indice_chamado_atual + 1

	if proximo_indice >= chamados.size():

		_finalizar_todos_chamados()

		return

	print("========================================")
	print("[TI] AVANÇANDO PARA O PRÓXIMO CHAMADO")
	print("[TI] Chamado ", proximo_indice + 1, " de ", chamados.size())
	print("========================================")

	await Transicao.transicao()

	carregar_chamado(proximo_indice)

	await Transicao.voltar()

# ============================================================
# TODOS OS CHAMADOS FINALIZADOS
# ============================================================

func _finalizar_todos_chamados() -> void:

	print("========================================")
	print("[TI] TODOS OS CHAMADOS FORAM RESOLVIDOS!")
	print("========================================")

	painel_chamado.visible = false

	Transicao.mudar_cena("res://scene/sala_tecnica.tscn")

func _abrir_ambiente_software(
	tipo: String = "verificacao_software"
) -> void:

	if executando_procedimento:
		return

	executando_procedimento = true

	print("========================================")
	print("[TI] ABRINDO AMBIENTE DE SOFTWARE")
	print("[TI] Tipo: ", tipo)
	print("========================================")

	painel_interacao.visible = false
	nome_objeto.visible = false

	var cena = preload(
		"res://scene/fase chamados/ambiente_software.tscn"
	)

	var instancia = cena.instantiate()

	instancia.tipo_atividade = tipo

	if instancia.has_signal("atividade_finalizada"):

		instancia.atividade_finalizada.connect(
			_ambiente_software_finalizado
		)

		print(
			"[TI] Sinal atividade_finalizada conectado."
		)

	else:

		push_error(
			"[TI] ERRO: ambiente_software não possui o sinal atividade_finalizada."
		)

	add_child(instancia)

func _ambiente_software_finalizado(resultado: Dictionary) -> void:

	print("========================================")
	print("[TI] RECEBI RESULTADO DO SOFTWARE")
	print("[TI] Resultado: ", resultado)
	print("========================================")

	executando_procedimento = false

	if resultado.get("resolvido", false):

		print("[TI] SOFTWARE RESOLVIDO COM SUCESSO!")

		_finalizar_chamado()

	else:

		print("[TI] O SOFTWARE NÃO FOI RESOLVIDO.")


func _on_btn_continuar_introducao_pressed() -> void:
	tutorial.visible = true
	introducao.visible = false


func _on_btn_continuar_tutorial_pressed() -> void:
	tutorial.visible = false
	carregar_chamado(0)
