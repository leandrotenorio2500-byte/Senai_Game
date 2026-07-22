extends Node

const _QUEST_SCREEN: PackedScene = preload("res://entities/mission_screen.tscn")

var _hud: CanvasLayer = null

# Dicionário que armazena as instâncias das missões (String id -> Quest objeto)
var missoes: Dictionary = {}

func _ready() -> void:
	_registrar_missao(QuestIdentificarRiscos.new())
	_registrar_missao(QuestChamados.new())

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

func _registrar_missao(quest: Quest) -> void:
	missoes[quest.id] = quest
	
	# Conecta os sinais de INICIADA e FINALIZADA
	quest.iniciada.connect(func(_id): _on_missao_iniciada(_id))
	quest.finalizada.connect(func(_id): _on_missao_finalizada(_id))

# ---------------- CONTROLE DE ESTADOS ----------------

func iniciar_missao(quest_id: String) -> void:
	if not missoes.has(quest_id): return
	var quest: Quest = missoes[quest_id]
	if quest.estado_atual == "nao_iniciada":
		quest.iniciar()

func progredir_missao(quest_id: String, dados: Dictionary = {}) -> void:
	if not missoes.has(quest_id): return
	var quest: Quest = missoes[quest_id]
	
	if quest.estado_atual == "em_andamento":
		quest.progredir(dados)

func obter_estado(quest_id: String) -> String:
	if missoes.has(quest_id):
		return missoes[quest_id].estado_atual
	return "nao_encontrada"

func obter_missao(quest_id: String) -> Quest:
	return missoes.get(quest_id, null)

# ---------------- GESTÃO DE HUD / UI ----------------

# Chamado quando a missão COMEÇA
func _on_missao_iniciada(quest_id: String) -> void:
	print("Missão iniciada: ", quest_id)
	
	if _hud == null:
		push_error("QuestManager: O HUD é NULL! Certifique-se de chamar QuestManager.register_hud(hud).")
		return

	var quest_ui: Node = _hud.get_node_or_null(quest_id)
	if quest_ui == null:
		quest_ui = _QUEST_SCREEN.instantiate()
		quest_ui.name = quest_id
		_hud.add_child(quest_ui)

	if quest_ui.has_method("show_started"):
		quest_ui.show_started(quest_id)

	# Exibe por 3.5s e remove o card da tela
	await get_tree().create_timer(3.5).timeout
	_remover_hud_missao(quest_id)

# Chamado quando a missão TERMINA
func _on_missao_finalizada(quest_id: String) -> void:
	print("Missão concluída: ", quest_id)
	
	if _hud == null:
		push_error("QuestManager: O HUD é NULL! Certifique-se de chamar QuestManager.register_hud(hud).")
		return

	var quest_ui: Node = _hud.get_node_or_null(quest_id)
	if quest_ui == null:
		quest_ui = _QUEST_SCREEN.instantiate()
		quest_ui.name = quest_id
		_hud.add_child(quest_ui)

	if quest_ui.has_method("show_completed"):
		quest_ui.show_completed()

	# Exibe por 3.5s e remove o card da tela
	await get_tree().create_timer(3.5).timeout
	_remover_hud_missao(quest_id)

func _remover_hud_missao(quest_id: String) -> void:
	if _hud == null: return
	var quest_ui = _hud.get_node_or_null(quest_id)
	if quest_ui:
		quest_ui.queue_free()
