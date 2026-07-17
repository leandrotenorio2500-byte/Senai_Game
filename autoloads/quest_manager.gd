extends Node

# --- SINAIS GLOBAIS (O que faltava para a Julia e outros scripts escutarem) ---
signal quest_started(quest_id: String)
signal quest_updated(quest_id: String)
signal quest_completed(quest_id: String)

const _QUEST_SCREEN: PackedScene = preload("res://entities/mission_screen.tscn")
var _hud: CanvasLayer = null

# Lista de missões do jogo na ordem em que devem acontecer
var fila_de_missoes: Array[Quest] = []
var missao_atual: Quest = null

func _ready() -> void:
	_inicializar_fila_de_missoes()
	_avancar_proxima_missao()

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

signal quest_started(quest_id) 
signal quest_updated(quest_id, step_index)
signal quest_completed(quest_id)

var quests = {
	"identificar_riscos": {
		"title": "Identificando riscos do mapa",
		"started": false,
		"current_step": 0,
		"completed": false,

		"steps": [
			{
				"description": "Converse com os responsáveis pelos setores",
				"target_count": 9,
				"current_count": 0
			},
			{
				"description": "Preencha corretamente o mapa de risco",
				"target_count": 1,
				"current_count": 0
			}
		]
	}
}

# Instancia ou atualiza a interface da missão na tela
func show_quest_ui(quest_id: String) -> void:
	if _hud == null:
		return
		
	# Pega a primeira missão da fila e remove ela da lista
	missao_atual = fila_de_missoes.pop_front()
	
	# Conecta rigidamente aos 3 sinais padrão que TODA missão possui
	missao_atual.iniciada.connect(_on_quest_iniciada)
	missao_atual.em_andamento.connect(_on_quest_em_andamento)
	missao_atual.finalizada.connect(_on_quest_finalizada)
	
	# --- LINHA REMOVIDA DAQUI ---
	# missao_atual.iniciar() <-- Tiramos isso para a missão começar como "pendente"
	
# Função global que qualquer objeto do mapa (ex: ponto de risco) chama para progredir
func notificar_progresso_missao(dados: Dictionary = {}) -> void:
	if missao_atual:
		missao_atual.progredir(dados)

# --- REATORES DOS SINAIS INTERNOS E EMISSÃO DE SINAIS GLOBAIS ---

func _on_quest_iniciada(quest_id: String) -> void:
	print("Gerenciador -> Missão [", quest_id, "] foi INICIADA.")
	show_quest_ui(quest_id)
	# Avisa globalmente o jogo (e a Julia) que a missão começou
	quest_started.emit(quest_id)

func _on_quest_em_andamento(quest_id: String) -> void:
	print("Gerenciador -> Missão [", quest_id, "] está EM ANDAMENTO.")
	show_quest_ui(quest_id)
	# Avisa globalmente o jogo (e a Julia) que a missão atualizou o progresso
	quest_updated.emit(quest_id)

func _on_quest_finalizada(quest_id: String) -> void:
	print("Gerenciador -> Missão [", quest_id, "] foi FINALIZADA!")
	show_quest_ui(quest_id)
	# Avisa globalmente o jogo (e a Julia) que a missão terminou
	quest_completed.emit(quest_id)
	
	# Aguarda os 2.5 segundos de feedback visual na HUD
	await get_tree().create_timer(2.5).timeout
	_limpar_hud()
	
	# Desconecta os sinais da missão antiga para evitar vazamento de memória
	missao_atual.iniciada.disconnect(_on_quest_iniciada)
	missao_atual.em_andamento.disconnect(_on_quest_em_andamento)
	missao_atual.finalizada.disconnect(_on_quest_finalizada)
	
	# Busca a próxima missão da fila automaticamente!
	_avancar_proxima_missao()

# --- GERENCIAMENTO DE HUD ---

func show_quest_ui(quest_id: String) -> void:
	if _hud == null or missao_atual == null: return
		
	for child in _hud.get_children():
		if child.has_method("update_display"):
			child.update_display(quest_id)
			if missao_atual.estado_atual == "finalizada":
				_customizar_textos_finais(child)
			return

	var new_quest_screen = _QUEST_SCREEN.instantiate()
	_hud.add_child(new_quest_screen)
	new_quest_screen.update_display(quest_id)
	
	if missao_atual.estado_atual == "finalizada":
		_customizar_textos_finais(new_quest_screen)

func _limpar_hud() -> void:
	if _hud:
		for child in _hud.get_children():
			if child.has_method("update_display"):
				child.queue_free()

func _customizar_textos_finais(root_node: Node) -> void:
	var lista_labels: Array[Node] = []
	_buscar_todos_labels(root_node, lista_labels)
	if lista_labels.size() > 0: lista_labels[0].text = "MISSÃO COMPLETA!"
	if lista_labels.size() > 1: lista_labels[1].text = "Parabéns pelo seu esforço!"

func _buscar_todos_labels(node: Node, lista: Array[Node]) -> void:
	if node is Label or node is RichTextLabel:
		lista.append(node)
	for child in node.get_children():
		_buscar_todos_labels(child, lista)
