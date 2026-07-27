extends CanvasLayer

signal monitor_fechado(acertou: bool)

@onready var btn_fechar: Button = $BtnFechar
@onready var btn_mouse: Button = $BtnMouse
@onready var btn_teclado: Button = $BtnTeclado
@onready var btn_monitor: Button = $BtnMonitor
@onready var btn_gabinete: Button = $BtnGabinete

var item_correto: String = "mouse_novo" 
var nome_npc: String = "Ana"
var faceset_npc: String = "res://sprites/npcs/npc3_dialog.png"

# Controla se estamos descobrindo o problema (false) ou instalando a peça (true)
var modo_instalacao: bool = false
var _processando_clique: bool = false

func _ready() -> void:
	var botoes: Array[Button] = [btn_fechar, btn_mouse, btn_teclado, btn_monitor, btn_gabinete]
	for btn in botoes:
		if btn:
			btn.focus_mode = Control.FOCUS_NONE

	btn_fechar.pressed.connect(_on_btn_fechar_pressed)
	btn_mouse.pressed.connect(func(): _verificar_clique("mouse_novo", "Mouse"))
	btn_teclado.pressed.connect(func(): _verificar_clique("teclado_novo", "Teclado"))
	btn_monitor.pressed.connect(func(): _verificar_clique("monitor_novo", "Monitor"))
	btn_gabinete.pressed.connect(func(): _verificar_clique("memoria_ram", "Gabinete"))

func _verificar_clique(item_clicado: String, nome_componente: String) -> void:
	if _processando_clique:
		return
	_processando_clique = true

	# ACERTOU O COMPONENTE
	if item_clicado == item_correto:
		var texto_sucesso: String = ""
		
		if modo_instalacao:
			texto_sucesso = "Excelente! Você instalou a peça nova no " + nome_componente + " e tudo voltou a funcionar perfeitamente!"
		else:
			texto_sucesso = "Isso mesmo! O problema é exatamente aqui no " + nome_componente + "!"

		var dialog_sucesso: Array[Dictionary] = [
			{
				"title": nome_npc,
				"dialog": texto_sucesso,
				"faceset": faceset_npc
			}
		]
		
		DialogManager.start_dialog(dialog_sucesso)
		
		if DialogManager.has_signal("dialog_ended"):
			await DialogManager.dialog_ended
			
		emit_signal("monitor_fechado", true)
		queue_free()

	# ERROU O COMPONENTE
	else:
		var fala_erro: String = ""
		
		if modo_instalacao:
			fala_erro = "Essa peça nova não encaixa no " + nome_componente + ". Tente colocar no componente correto!"
		else:
			fala_erro = _obter_fala_erro_diagnostico(nome_componente)

		var dialog_erro: Array[Dictionary] = [
			{
				"title": nome_npc,
				"dialog": fala_erro,
				"faceset": faceset_npc
			}
		]
		
		DialogManager.start_dialog(dialog_erro)
		
		if DialogManager.has_signal("dialog_ended"):
			await DialogManager.dialog_ended
		
		_processando_clique = false

func _obter_fala_erro_diagnostico(componente: String) -> String:
	match componente:
		"Teclado":
			return "Hum... O teclado está digitando normalmente, todas as teclas respondem. O problema não é aqui."
		"Monitor":
			return "A imagem do monitor está perfeita, sem falhas nem piscando. Não é no monitor o defeito."
		"Gabinete":
			return "O gabinete está silencioso e funcionando bem. O problema não parece ser nas peças internas."
		"Mouse":
			return "O ponteiro do mouse se move sem problemas. O defeito não está no mouse."
		_:
			return "Examinei este ponto, mas parece estar tudo funcionando corretamente."

func _on_btn_fechar_pressed() -> void:
	if _processando_clique:
		return
	emit_signal("monitor_fechado", false)
	queue_free()
