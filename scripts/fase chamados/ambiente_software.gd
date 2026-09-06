extends Control

signal atividade_finalizada(resultado: Dictionary)
# ============================================================
# ÁREA DE TRABALHO
# ============================================================

@onready var btn_fechar: TextureButton = (
	$AreaTrabalho/TelaMonitor/Desligar
)

@onready var btn_gerenciador: TextureButton = (
	$AreaTrabalho/TelaMonitor/GerenciadorTarefas
)


# ============================================================
# GERENCIADOR DE TAREFAS
# ============================================================

@onready var gerenciador_tarefas: Control = (
	$AreaTrabalho/Gerenc_Tarefas
)

@onready var btn_fechar_gerenc: TextureButton = (
	$AreaTrabalho/Gerenc_Tarefas/TextureButton
)

@onready var btn_encerrar_tarefa: Button = (
	$AreaTrabalho/Gerenc_Tarefas/EncerrarTarefa
)

@onready var label_feedback: Label = (
	$AreaTrabalho/Gerenc_Tarefas/FeedbackSoftware
)


# ============================================================
# APLICATIVOS
# ============================================================

@onready var app_1: Button = (
	$AreaTrabalho/Gerenc_Tarefas/Aplicativos/App1
)

@onready var app_2: Button = (
	$AreaTrabalho/Gerenc_Tarefas/Aplicativos/App2
)

@onready var app_3: Button = (
	$AreaTrabalho/Gerenc_Tarefas/Aplicativos/App3
)

@onready var app_4: Button = (
	$AreaTrabalho/Gerenc_Tarefas/Aplicativos/App4
)

@onready var app_5: Button = (
	$AreaTrabalho/Gerenc_Tarefas/Aplicativos/App5
)


# ============================================================
# CPU
# ============================================================

@onready var cpu_1: Label = (
	$AreaTrabalho/Gerenc_Tarefas/CPU/App1
)

@onready var cpu_2: Label = (
	$AreaTrabalho/Gerenc_Tarefas/CPU/App2
)

@onready var cpu_3: Label = (
	$AreaTrabalho/Gerenc_Tarefas/CPU/App3
)

@onready var cpu_4: Label = (
	$AreaTrabalho/Gerenc_Tarefas/CPU/App4
)

@onready var cpu_5: Label = (
	$AreaTrabalho/Gerenc_Tarefas/CPU/App5
)


# ============================================================
# ESTADOS
# ============================================================

enum Estado {
	AREA_TRABALHO,
	GERENCIADOR_TAREFAS,
	PROCESSO_SELECIONADO,
	RESOLVENDO,
	RESOLVIDO
}

var estado_atual: Estado = Estado.AREA_TRABALHO


# ============================================================
# PROCESSO SELECIONADO
# ============================================================

var processo_selecionado := ""

var indice_processo_selecionado := -1

var tipo_atividade := "verificacao_software"

var janela_fila: Control = null

# ============================================================
# CONTROLE
# ============================================================

var atividade_concluida := false


# ============================================================
# PROCESSOS
# ============================================================

var processos := [

	{
		"nome": "Sistema",
		"cpu": 7,
		"problema": false
	},

	{
		"nome": "Explorador",
		"cpu": 4,
		"problema": false
	},

	{
		"nome": "Navegador",
		"cpu": 13,
		"problema": false
	},

	{
		"nome": "Atualizador",
		"cpu": 6,
		"problema": false
	},

	{
		"nome": "Backup_Servico",
		"cpu": 92,
		"problema": true
	}
]

func _abrir_fila_impressao() -> void:

	print("========================================")
	print("[SOFTWARE] ABRINDO FILA DE IMPRESSÃO")
	print("========================================")

	var cena = preload(
		"res://scene/fase chamados/ambiente_fila_impressao.tscn"
		
	)

	janela_fila = cena.instantiate()

	if janela_fila.has_signal("atividade_finalizada"):

		janela_fila.atividade_finalizada.connect(
			_fila_impressao_finalizada
		)

		print(
			"[SOFTWARE] Sinal da fila de impressão conectado."
		)

	else:

		push_error(
			"[SOFTWARE] ERRO: JanelaFila não possui atividade_finalizada."
		)

	add_child(janela_fila)
	
func _fila_impressao_finalizada(resultado: Dictionary) -> void:

	print("========================================")
	print("[SOFTWARE] RECEBI RESULTADO DA FILA")
	print("[SOFTWARE] Resultado: ", resultado)
	print("========================================")

	if resultado.get("resolvido", false):

		print("[SOFTWARE] FILA DE IMPRESSÃO RESOLVIDA!")

		atividade_finalizada.emit({
			"resolvido": true,
			"tipo": "verificacao_impressao"
		})

	else:

		print("[SOFTWARE] FILA DE IMPRESSÃO NÃO RESOLVIDA.")

func _configurar_atividade() -> void:

	match tipo_atividade:

		"verificacao_software":

			print(
				"[SOFTWARE] Modo: Gerenciador de Tarefas."
			)

		"verificacao_impressao":

			print(
				"[SOFTWARE] Modo: Fila de Impressão."
			)

			call_deferred("_abrir_fila_impressao")

		_:

			push_error(
				"[SOFTWARE] Tipo de atividade desconhecido: " +
				tipo_atividade
			)

# ============================================================
# INICIALIZAÇÃO
# ============================================================

func _ready() -> void:
	_configurar_atividade()
	# --------------------------------------------------------
	# BOTÕES PRINCIPAIS
	# --------------------------------------------------------

	#btn_fechar.pressed.connect(
		#_fechar
	#)

	btn_gerenciador.pressed.connect(
		_abrir_gerenciador
	)

	btn_fechar_gerenc.pressed.connect(
		_fechar_gerenciador
	)


	# --------------------------------------------------------
	# BOTÃO ENCERRAR
	# --------------------------------------------------------

	btn_encerrar_tarefa.pressed.connect(
		_encerrar_processo
	)


	# --------------------------------------------------------
	# APLICATIVOS
	# --------------------------------------------------------

	app_1.pressed.connect(
		func():
			selecionar_processo(0)
	)

	app_2.pressed.connect(
		func():
			selecionar_processo(1)
	)

	app_3.pressed.connect(
		func():
			selecionar_processo(2)
	)

	app_4.pressed.connect(
		func():
			selecionar_processo(3)
	)

	app_5.pressed.connect(
		func():
			selecionar_processo(4)
	)


	# --------------------------------------------------------
	# ESTADO INICIAL
	# --------------------------------------------------------

	gerenciador_tarefas.visible = false

	btn_encerrar_tarefa.visible = false

	label_feedback.visible = false

	atividade_concluida = false

	estado_atual = Estado.AREA_TRABALHO

	_configurar_processos()


# ============================================================
# CONFIGURAR PROCESSOS
# ============================================================

func _configurar_processos() -> void:

	app_1.text = processos[0]["nome"]
	app_2.text = processos[1]["nome"]
	app_3.text = processos[2]["nome"]
	app_4.text = processos[3]["nome"]
	app_5.text = processos[4]["nome"]


	cpu_1.text = str(processos[0]["cpu"]) + "%"

	cpu_2.text = str(processos[1]["cpu"]) + "%"

	cpu_3.text = str(processos[2]["cpu"]) + "%"

	cpu_4.text = str(processos[3]["cpu"]) + "%"

	cpu_5.text = str(processos[4]["cpu"]) + "%"


# ============================================================
# ABRIR GERENCIADOR
# ============================================================

func _abrir_gerenciador() -> void:

	print("[SOFTWARE] Abrindo Gerenciador de Tarefas...")

	gerenciador_tarefas.visible = true

	estado_atual = Estado.GERENCIADOR_TAREFAS

	processo_selecionado = ""

	indice_processo_selecionado = -1

	btn_encerrar_tarefa.visible = false

	label_feedback.visible = false

	print("[SOFTWARE] Processos carregados.")


# ============================================================
# SELECIONAR PROCESSO
# ============================================================

func selecionar_processo(indice: int) -> void:

	if estado_atual != Estado.GERENCIADOR_TAREFAS:
		return

	if indice < 0 or indice >= processos.size():
		return


	var processo: Dictionary = processos[indice]

	processo_selecionado = processo["nome"]

	indice_processo_selecionado = indice

	estado_atual = Estado.PROCESSO_SELECIONADO


	print(
		"[SOFTWARE] Processo selecionado: ",
		processo_selecionado
	)

	print(
		"[SOFTWARE] Uso de CPU: ",
		processo["cpu"],
		"%"
	)


	_mostrar_opcao_encerrar()


# ============================================================
# MOSTRAR OPÇÃO DE ENCERRAR
# ============================================================

func _mostrar_opcao_encerrar() -> void:

	btn_encerrar_tarefa.visible = true

	print(
		"[SOFTWARE] Opção 'Encerrar tarefa' disponível."
	)


# ============================================================
# ENCERRAR PROCESSO
# ============================================================

func _encerrar_processo() -> void:

	if estado_atual != Estado.PROCESSO_SELECIONADO:
		return

	if indice_processo_selecionado < 0:
		return


	var processo: Dictionary = (
		processos[indice_processo_selecionado]
	)


	print(
		"[SOFTWARE] Tentando encerrar: ",
		processo["nome"]
	)


	# ========================================================
	# PROCESSO CORRETO
	# ========================================================

	if processo["problema"]:

		_iniciar_resolucao()

		return


	# ========================================================
	# PROCESSO INCORRETO
	# ========================================================

	_mostrar_feedback_erro()


# ============================================================
# INICIAR RESOLUÇÃO
# ============================================================

func _iniciar_resolucao() -> void:

	estado_atual = Estado.RESOLVENDO

	btn_encerrar_tarefa.visible = false

	app_1.disabled = true
	app_2.disabled = true
	app_3.disabled = true
	app_4.disabled = true
	app_5.disabled = true

	label_feedback.visible = true

	label_feedback.text = (
		"Encerrando processo..."
	)

	print(
		"[SOFTWARE] Encerrando processo: ",
		processo_selecionado
	)

	await get_tree().create_timer(1.0).timeout

	# --------------------------------------------------------
	# Processo encerrado
	# --------------------------------------------------------

	label_feedback.text = (
		"Processo encerrado.\n" +
	    "Verificando uso da CPU..."
	)

	print(
		"[SOFTWARE] Processo encerrado."
	)

	await get_tree().create_timer(1.0).timeout

	# --------------------------------------------------------
	# Inicia redução da CPU
	# --------------------------------------------------------

	await _reduzir_cpu()


# ============================================================
# REDUZIR CPU
# ============================================================

func _reduzir_cpu() -> void:

	var valores_cpu := [
		68,
		51,
		36,
		24,
		15,
		9
	]


	for valor in valores_cpu:

		processos[4]["cpu"] = valor

		_configurar_processos()

		label_feedback.text = (
			"Uso da CPU: " +
			str(valor) +
			"%"
		)

		await get_tree().create_timer(0.35).timeout


	# --------------------------------------------------------
	# CPU estabilizada
	# --------------------------------------------------------

	processos[4]["cpu"] = 0

	_configurar_processos()

	label_feedback.text = (
		"Uso da CPU normalizado."
	)

	print(
		"[SOFTWARE] CPU normalizada."
	)

	await get_tree().create_timer(1.5).timeout


	# --------------------------------------------------------
	# Finalização
	# --------------------------------------------------------

	label_feedback.text = (
		"Computador funcionando normalmente."
	)

	print(
		"[SOFTWARE] Computador funcionando normalmente."
	)

	await get_tree().create_timer(1.5).timeout


	_finalizar_procedimento_software()


# ============================================================
# PROCESSO INCORRETO
# ============================================================

func _mostrar_feedback_erro() -> void:

	print("========================================")
	print("[SOFTWARE] PROCESSO INCORRETO!")
	print(
		"[SOFTWARE] ",
		processo_selecionado,
		" não apresenta comportamento anormal."
	)
	print("========================================")


	estado_atual = Estado.GERENCIADOR_TAREFAS

	processo_selecionado = ""

	indice_processo_selecionado = -1

	btn_encerrar_tarefa.visible = false


# ============================================================
# FINALIZAR PROCEDIMENTO
# ============================================================

func _finalizar_procedimento_software() -> void:

	atividade_concluida = true

	estado_atual = Estado.RESOLVIDO

	var processo_resolvido := processo_selecionado

	processo_selecionado = ""
	indice_processo_selecionado = -1


	print("========================================")
	print("[SOFTWARE] PROCEDIMENTO CONCLUÍDO!")
	print("[SOFTWARE] Computador normalizado.")
	print("========================================")


	# --------------------------------------------------------
	# REATIVA OS APLICATIVOS
	# --------------------------------------------------------

	app_1.disabled = false
	app_2.disabled = false
	app_3.disabled = false
	app_4.disabled = false
	app_5.disabled = false


	# --------------------------------------------------------
	# MANTÉM A MENSAGEM FINAL
	# --------------------------------------------------------

	label_feedback.visible = true
	label_feedback.text = "Computador funcionando normalmente."


	await get_tree().create_timer(2.0).timeout


	# --------------------------------------------------------
	# ENVIA RESULTADO PARA A BANCADATI
	# --------------------------------------------------------

	print("[SOFTWARE] Enviando resultado para a BancadaTI...")

	atividade_finalizada.emit({
		"resolvido": true,
		"tipo": "verificacao_software",
		"processo": processo_resolvido
	})

	print("[SOFTWARE] Resultado enviado!")


	# --------------------------------------------------------
	# FECHA O AMBIENTE DE SOFTWARE
	# --------------------------------------------------------

	queue_free()


# ============================================================
# FECHAR GERENCIADOR
# ============================================================

func _fechar_gerenciador() -> void:

	if estado_atual == Estado.RESOLVENDO:
		return


	gerenciador_tarefas.visible = false

	processo_selecionado = ""

	indice_processo_selecionado = -1

	btn_encerrar_tarefa.visible = false

	label_feedback.visible = false

	estado_atual = Estado.AREA_TRABALHO

	print("[SOFTWARE] Gerenciador de Tarefas fechado.")


# ============================================================
# FECHAR SOFTWARE
# ============================================================

#func _fechar() -> void:

	#if estado_atual == Estado.RESOLVENDO:
		#return

	#print("[SOFTWARE] Fechando ambiente de software.")

	#queue_free()
