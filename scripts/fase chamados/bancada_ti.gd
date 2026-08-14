extends Control


# ============================================================
# PAINEL DO CHAMADO
# ============================================================

@onready var painel_chamado: Panel = $PainelChamado

@onready var label_titulo: Label = $PainelChamado/VBoxContainer/LabelTitulo
@onready var label_funcionario: Label = $PainelChamado/VBoxContainer/LabelFuncionario
@onready var label_setor: Label = $PainelChamado/VBoxContainer/LabelSetor
@onready var label_problema: Label = $PainelChamado/VBoxContainer/LabelProblema
@onready var label_objetivo: Label = $PainelChamado/VBoxContainer/LabelObjetivo


# ============================================================
# PAINEL DE INTERAÇÃO
# ============================================================

@onready var painel_interacao: Control = $PainelInteracao

@onready var label_descricao: Label = $PainelInteracao/NinePatchRect/LabelDescricao

@onready var btn_interacao_1: Button = $PainelInteracao/NinePatchRect/opcao1
@onready var btn_interacao_2: Button = $PainelInteracao/NinePatchRect/opcao2
@onready var btn_interacao_3: Button = $PainelInteracao/NinePatchRect/opcao3
@onready var btn_fechar: Button = $PainelInteracao/NinePatchRect/fechar


# ============================================================
# FEEDBACK
# ============================================================

@onready var label_feedback: Label = $PainelInteracao/NinePatchRect/LabelFeedback


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
# OBJETO SELECIONADO
# ============================================================

var objeto_selecionado := ""


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
		"funcionario": "Ana",
		"problema": "mouse_com_defeito",
		"descricao": "O mouse está apresentando falhas durante o uso.",
		"equipamento": "mouse",
		"acao": "substituir_mouse"
	},

	{
		"id": "chamado_02",
		"setor": "RH",
		"funcionario": "Vitória",
		"problema": "sem_imagem",
		"descricao": "O computador liga, mas o monitor não apresenta imagem.",
		"equipamento": "monitor",
		"acao": "verificar_cabo"
	},

	{
		"id": "chamado_03",
		"setor": "Produção",
		"funcionario": "Thiago",
		"problema": "computador_lento",
		"descricao": "O computador está muito lento durante o uso.",
		"equipamento": "gabinete",
		"acao": "verificar_software"
	},

	{
		"id": "chamado_04",
		"setor": "Diretoria",
		"funcionario": "Michele",
		"problema": "impressora",
		"descricao": "A impressora não está realizando as impressões.",
		"equipamento": "impressora",
		"acao": "verificar_impressao"
	}
]


# ============================================================
# INICIALIZAÇÃO
# ============================================================

func _ready() -> void:

	# --------------------------------------------------------
	# Equipamentos
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
	# Hover dos equipamentos
	# --------------------------------------------------------

	btn_monitor.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Monitor")
	)

	btn_monitor.mouse_exited.connect(
		_esconder_nome_objeto
	)


	btn_gabinete.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Gabinete")
	)

	btn_gabinete.mouse_exited.connect(
		_esconder_nome_objeto
	)


	btn_teclado.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Teclado")
	)

	btn_teclado.mouse_exited.connect(
		_esconder_nome_objeto
	)


	btn_mouse.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Mouse")
	)

	btn_mouse.mouse_exited.connect(
		_esconder_nome_objeto
	)


	btn_impressora.mouse_entered.connect(
		func(): _mostrar_nome_objeto("Impressora")
	)

	btn_impressora.mouse_exited.connect(
		_esconder_nome_objeto
	)


	# --------------------------------------------------------
	# Botões do painel
	# --------------------------------------------------------

	btn_interacao_1.pressed.connect(
		func(): _selecionar_opcao(1)
	)

	btn_interacao_2.pressed.connect(
		func(): _selecionar_opcao(2)
	)

	btn_interacao_3.pressed.connect(
		func(): _selecionar_opcao(3)
	)

	btn_fechar.pressed.connect(
		_fechar_painel_interacao
	)


	# --------------------------------------------------------
	# Estados iniciais
	# --------------------------------------------------------

	nome_objeto.visible = false
	painel_interacao.visible = false
	label_feedback.visible = false


	# --------------------------------------------------------
	# Primeiro chamado
	# --------------------------------------------------------

	carregar_chamado(0)


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

	objeto_selecionado = ""


	print("========================================")
	print("[TI] CHAMADO CARREGADO")
	print("[TI] ID: ", chamado_atual["id"])
	print("[TI] Funcionário: ", chamado_atual["funcionario"])
	print("[TI] Setor: ", chamado_atual["setor"])
	print("[TI] Problema: ", chamado_atual["problema"])
	print("========================================")


	atualizar_painel()


# ============================================================
# INTERAÇÃO COM OBJETO
# ============================================================

func _interagir(objeto: String) -> void:

	print("[TI] Objeto clicado: ", objeto)

	objeto_selecionado = objeto

	_configurar_painel_interacao(objeto)


# ============================================================
# CONFIGURAR PAINEL DE INTERAÇÃO
# ============================================================

func _configurar_painel_interacao(objeto: String) -> void:

	painel_interacao.visible = true
	label_feedback.visible = false
	label_descricao.visible = true


	match objeto:

		"mouse":

			label_descricao.text = "O que fazer?"

			btn_interacao_1.text = "Testar mouse"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Trocar mouse"


		"monitor":

			label_descricao.text = "O que fazer?"

			btn_interacao_1.text = "Testar monitor"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Verificar energia"


		"gabinete":

			label_descricao.text = "O que fazer?"

			btn_interacao_1.text = "Ligar computador"
			btn_interacao_2.text = "Verificar componentes"
			btn_interacao_3.text = "Verificar software"


		"teclado":

			label_descricao.text = "O que fazer?"

			btn_interacao_1.text = "Testar teclado"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Trocar teclado"


		"impressora":

			label_descricao.text = "O que fazer?"

			btn_interacao_1.text = "Testar impressão"
			btn_interacao_2.text = "Verificar conexão"
			btn_interacao_3.text = "Verificar papel"


		_:

			painel_interacao.visible = false


# ============================================================
# SELECIONAR OPÇÃO
# ============================================================

func _selecionar_opcao(opcao: int) -> void:

	print("[TI] Opção selecionada: ", opcao)
	print("[TI] Objeto: ", objeto_selecionado)

	match objeto_selecionado:

		"mouse":
			_interacao_mouse(opcao)

		"monitor":
			_interacao_monitor(opcao)

		"gabinete":
			_interacao_gabinete(opcao)

		"teclado":
			_interacao_teclado(opcao)

		"impressora":
			_interacao_impressora(opcao)


# ============================================================
# INTERAÇÕES DO MOUSE
# ============================================================

func _interacao_mouse(opcao: int) -> void:

	match opcao:

		1:
			_mostrar_feedback(
				"Testando o mouse...\n\nO cursor não está respondendo corretamente."
			)

		2:
			_mostrar_feedback(
				"Verificando conexão...\n\nO cabo do mouse está conectado corretamente."
			)

		3:
			_mostrar_feedback(
				"O mouse apresenta sinais de defeito.\n\nTalvez seja necessário substituí-lo."
			)


# ============================================================
# INTERAÇÕES DO MONITOR
# ============================================================

func _interacao_monitor(opcao: int) -> void:

	match opcao:

		1:
			_mostrar_feedback(
				"Testando o monitor...\n\nO monitor está ligado, mas não apresenta imagem."
			)

		2:
			_mostrar_feedback(
				"Verificando conexão...\n\nÉ necessário verificar o cabo de vídeo."
			)

		3:
			_mostrar_feedback(
				"Verificando energia...\n\nO monitor está recebendo energia normalmente."
			)


# ============================================================
# INTERAÇÕES DO GABINETE
# ============================================================

func _interacao_gabinete(opcao: int) -> void:

	match opcao:

		1:
			_mostrar_feedback(
				"Ligando o computador...\n\nO computador está funcionando."
			)

		2:
			_mostrar_feedback(
				"Verificando componentes...\n\nNenhum problema físico aparente foi encontrado."
			)

		3:
			_mostrar_feedback(
				"Verificando o software...\n\nO sistema apresenta lentidão durante o uso."
			)


# ============================================================
# INTERAÇÕES DO TECLADO
# ============================================================

func _interacao_teclado(opcao: int) -> void:

	match opcao:

		1:
			_mostrar_feedback(
				"Testando o teclado...\n\nAs teclas estão respondendo normalmente."
			)

		2:
			_mostrar_feedback(
				"Verificando conexão...\n\nO teclado está conectado corretamente."
			)

		3:
			_mostrar_feedback(
				"O teclado não apresenta sinais de defeito que justifiquem a troca."
			)


# ============================================================
# INTERAÇÕES DA IMPRESSORA
# ============================================================

func _interacao_impressora(opcao: int) -> void:

	match opcao:

		1:
			_mostrar_feedback(
				"Realizando teste de impressão...\n\nA impressão não foi concluída."
			)

		2:
			_mostrar_feedback(
				"Verificando conexão...\n\nA impressora está conectada ao computador."
			)

		3:
			_mostrar_feedback(
				"Verificando papel...\n\nA bandeja possui papel normalmente."
			)


# ============================================================
# MOSTRAR FEEDBACK
# ============================================================

func _mostrar_feedback(texto: String) -> void:

	label_descricao.visible = false

	btn_interacao_1.visible = false
	btn_interacao_2.visible = false
	btn_interacao_3.visible = false

	label_feedback.visible = true

	label_feedback.text = texto


# ============================================================
# FECHAR FEEDBACK / VOLTAR
# ============================================================

func _fechar_painel_interacao() -> void:

	painel_interacao.visible = false

	label_feedback.visible = false

	btn_interacao_1.visible = true
	btn_interacao_2.visible = true
	btn_interacao_3.visible = true


# ============================================================
# NOME DO OBJETO
# ============================================================

func _mostrar_nome_objeto(nome: String) -> void:

	nome_objeto.text = nome

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
# INVESTIGAÇÃO
# ============================================================

func _investigar(objeto: String) -> void:

	print("[TI] Investigando: ", objeto)

	var equipamento_correto: String = chamado_atual["equipamento"]

	if objeto != equipamento_correto:

		print("[TI] Esse não parece ser o equipamento com problema.")

		return


	print("========================================")
	print("[TI] PROBLEMA IDENTIFICADO!")
	print("[TI] Equipamento: ", chamado_atual["equipamento"])
	print("[TI] Ação necessária: ", chamado_atual["acao"])
	print("========================================")


	etapa_atual = Etapa.ACAO

	atualizar_painel()


# ============================================================
# AÇÃO
# ============================================================

func _executar_acao(objeto: String) -> void:

	match chamado_atual.get("acao", ""):

		"substituir_mouse":
			_acao_substituir_mouse(objeto)

		"verificar_cabo":
			_acao_verificar_cabo(objeto)

		"verificar_software":
			_acao_verificar_software(objeto)

		"verificar_impressao":
			_acao_verificar_impressao(objeto)

		_:
			print(
				"[TI] Ação desconhecida: ",
				chamado_atual.get("acao", "")
			)


# ============================================================
# SUBSTITUIR MOUSE
# ============================================================

func _substituir_mouse() -> void:

	print("[TI] Removendo mouse antigo...")

	btn_mouse.disabled = true

	await get_tree().create_timer(0.5).timeout

	print("[TI] Instalando mouse novo...")

	if mouse_novo_texture:

		btn_mouse.texture_normal = mouse_novo_texture
		btn_mouse.texture_hover = mouse_novo_texture
		btn_mouse.texture_pressed = mouse_novo_texture

	btn_mouse.disabled = false

	await get_tree().create_timer(0.5).timeout

	print("[TI] Testando mouse...")

	await get_tree().create_timer(0.5).timeout

	print("[TI] Mouse funcionando corretamente!")

	_finalizar_chamado()


func _acao_substituir_mouse(objeto: String) -> void:

	if objeto != "mouse":

		print("[TI] A ação deve ser realizada no mouse.")

		return

	print("[TI] Substituindo mouse...")

	_substituir_mouse()


# ============================================================
# OUTRAS AÇÕES
# ============================================================

func _acao_verificar_software(objeto: String) -> void:

	print("[TI] Ação: verificar software")
	print("[TI] Objeto clicado: ", objeto)


func _acao_verificar_cabo(objeto: String) -> void:

	print("[TI] Ação: verificar cabo")
	print("[TI] Objeto clicado: ", objeto)


func _acao_verificar_impressao(objeto: String) -> void:

	print("[TI] Ação: verificar impressão")
	print("[TI] Objeto clicado: ", objeto)


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
		"Funcionário: " +
		str(chamado_atual.get("funcionario", ""))
	)


	label_setor.text = (
		"Setor: " +
		str(chamado_atual.get("setor", ""))
	)


	label_problema.text = (
		"Problema:\n" +
		str(chamado_atual.get("descricao", ""))
	)


	match etapa_atual:

		Etapa.INVESTIGACAO:

			label_objetivo.text = (
				"Objetivo:\n" +
				"Identifique o equipamento com problema."
			)


		Etapa.ACAO:

			label_objetivo.text = (
				"Problema identificado!\n\n" +
				"Ação:\n" +
				_descricao_acao()
			)


		Etapa.FINALIZADO:

			label_objetivo.text = (
				"✓ Chamado resolvido!"
			)


# ============================================================
# FINALIZAR
# ============================================================

func _finalizar_chamado() -> void:

	etapa_atual = Etapa.FINALIZADO

	atualizar_painel()

	print("========================================")
	print("[TI] CHAMADO RESOLVIDO!")
	print("[TI] ", chamado_atual["funcionario"])
	print("[TI] ", chamado_atual["setor"])
	print("========================================")
