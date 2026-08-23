extends Control

signal atividade_finalizada(resultado: Dictionary)


enum Estado {
	FILA_COM_PROBLEMA,
	CANCELANDO,
	FILA_LIMPA,
	TESTANDO,
	RESOLVIDO
}

var documento_selecionado: Button = null
var estado_atual: Estado = Estado.FILA_COM_PROBLEMA
var documentos_na_fila := true
var atividade_concluida := false

@onready var documento_1: Button = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaDocumentos/Doc1
@onready var documento_2: Button =$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaDocumentos/Doc2
@onready var documento_3: Button = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaDocumentos/Doc3
@onready var documento_4: Button = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaDocumentos/Doc4

@onready var status_1: Label = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaStatus/Status1
@onready var status_2: Label = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaStatus/Status2
@onready var status_3: Label = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaStatus/Status3
@onready var status_4: Label = $AreaTrabalho/TelaMonitor/JanelaFila/Fundo/ListaStatus/Status4


@onready var btn_cancelar_documento: Button = (
	$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/CancelarDoc
)

@onready var btn_cancelar_todos: Button = (
	$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/CancelarTodos
)

@onready var btn_imprimir_teste: Button = (
	$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/Teste
)

@onready var btn_fechar: TextureButton = (
	$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/Fechar
)

@onready var label_feedback: Label = (
	$AreaTrabalho/TelaMonitor/JanelaFila/Fundo/Feedback
)

func _ready() -> void:

	btn_cancelar_documento.pressed.connect(
		_cancelar_documento
	)

	btn_cancelar_todos.pressed.connect(
		_cancelar_todos
	)

	btn_imprimir_teste.pressed.connect(
		_imprimir_teste
	)

	btn_fechar.pressed.connect(
		_fechar
	)


	documento_1.pressed.connect(
		func(): _selecionar_documento(documento_1)
	)

	documento_2.pressed.connect(
		func(): _selecionar_documento(documento_2)
	)

	documento_3.pressed.connect(
		func(): _selecionar_documento(documento_3)
	)

	documento_4.pressed.connect(
		func(): _selecionar_documento(documento_4)
	)

	btn_cancelar_todos.visible = false
	btn_cancelar_documento.visible = false
	btn_imprimir_teste.visible = false
	label_feedback.visible = false

	_configurar_fila()
		
func _selecionar_documento(documento: Button) -> void:

	if estado_atual != Estado.FILA_COM_PROBLEMA:
		return

	documento_selecionado = documento

	btn_cancelar_documento.visible = true
	btn_cancelar_todos.visible = true
	label_feedback.visible = false
	label_feedback.text = (
		"Documento selecionado:\n" +
		documento.text
	)

	print("[IMPRESSORA] Documento selecionado: ", documento.text)
	
func _obter_status_documento(documento: Button) -> Label:

	if documento == documento_1:
		return status_1

	if documento == documento_2:
		return status_2

	if documento == documento_3:
		return status_3

	if documento == documento_4:
		return status_4

	return null

func _configurar_fila() -> void:


	documento_1.text = "Documento_03.pdf"
	status_1.text = "Erro"

	documento_2.text = "Documento_04.pdf"
	status_2.text = "Erro"
	
	documento_3.text = "Relatorio_Michele.pdf"
	status_3.text = "Aguardando"

	documento_4.text = "Memorando_Diretoria.docx"
	status_4.text = "Aguardando"


	btn_cancelar_documento.disabled = false
	btn_cancelar_todos.disabled = false
	btn_imprimir_teste.visible = false

	documento_1.disabled = false
	documento_2.disabled = false
	documento_3.disabled = false
	documento_4.disabled = false

	documentos_na_fila = true
	estado_atual = Estado.FILA_COM_PROBLEMA
	
func _cancelar_documento() -> void:

	if estado_atual != Estado.FILA_COM_PROBLEMA:
		return


	if documento_selecionado == null:

		label_feedback.visible = true
		label_feedback.text = "Selecione um documento para cancelar."

		return


	print(
		"[IMPRESSORA] Cancelando documento: ",
		documento_selecionado.text
	)


	var status: Label = _obter_status_documento(
		documento_selecionado
	)

	if status != null:
		status.text = "Cancelado"


	documento_selecionado.disabled = true

	label_feedback.visible = true
	label_feedback.text = "Documento cancelado."

	documento_selecionado = null


# --------------------------------------------------------
# VERIFICAR SE OS DOCUMENTOS COM ERRO FORAM CANCELADOS
# --------------------------------------------------------

	if documento_1.disabled and documento_2.disabled:

		documentos_na_fila = false
		estado_atual = Estado.FILA_LIMPA

		label_feedback.text = (
			"Os trabalhos com erro foram removidos da fila."
		)

		btn_cancelar_documento.disabled = true
		btn_cancelar_todos.disabled = true
		btn_imprimir_teste.visible = true

func _cancelar_todos() -> void:

	if estado_atual != Estado.FILA_COM_PROBLEMA:
		return

	estado_atual = Estado.CANCELANDO

	btn_cancelar_documento.disabled = true
	btn_cancelar_todos.disabled = true

	label_feedback.visible = true
	label_feedback.text = "Cancelando trabalhos de impressão..."

	await get_tree().create_timer(1.0).timeout

	status_1.text = "Cancelado"
	documento_1.disabled = true

	await get_tree().create_timer(0.5).timeout

	status_2.text = "Cancelado"
	documento_2.disabled = true

	await get_tree().create_timer(0.5).timeout

	status_3.text = "Cancelado"
	documento_3.disabled = true

	await get_tree().create_timer(0.5).timeout

	status_4.text = "Cancelado"
	documento_4.disabled = true

	await get_tree().create_timer(0.8).timeout

	documentos_na_fila = false
	estado_atual = Estado.FILA_LIMPA

	label_feedback.text = "Fila de impressão limpa."

	btn_imprimir_teste.visible = true
	
func _imprimir_teste() -> void:

	if estado_atual != Estado.FILA_LIMPA:
		return

	estado_atual = Estado.TESTANDO

	btn_imprimir_teste.disabled = true

	label_feedback.text = "Enviando página de teste..."
	label_feedback.visible = true

	await get_tree().create_timer(1.0).timeout

	label_feedback.text = "Imprimindo página de teste..."

	await get_tree().create_timer(1.2).timeout

	label_feedback.text = "Página de teste impressa com sucesso."

	await get_tree().create_timer(1.5).timeout

	_finalizar()
	
func _finalizar() -> void:

	estado_atual = Estado.RESOLVIDO
	atividade_concluida = true

	print("========================================")
	print("[IMPRESSORA] FILA DE IMPRESSÃO RESOLVIDA!")
	print("========================================")

	atividade_finalizada.emit({
		"resolvido": true,
		"tipo": "verificacao_impressao"
	})

	queue_free()
	
func _fechar() -> void:

	if estado_atual == Estado.CANCELANDO:
		return

	if estado_atual == Estado.TESTANDO:
		return

	queue_free()
