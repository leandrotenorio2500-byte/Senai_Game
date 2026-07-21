extends Node

const _QUEST_SCREEN: PackedScene = preload("res://entities/mission_screen.tscn")

var _hud: CanvasLayer = null

# Dicionário que armazena as instâncias das missões (String id -> Quest objeto)
var missoes: Dictionary = {}

func _ready() -> void:
	_registrar_missao(QuestIdentificarRiscos.new())

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

func _registrar_missao(quest: Quest) -> void:
	missoes[quest.id] = quest
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
	
	# Garante que vai progredir se a missão estiver "em_andamento"
	if quest.estado_atual == "em_andamento":
		quest.progredir(dados)

func obter_estado(quest_id: String) -> String:
	if missoes.has(quest_id):
		return missoes[quest_id].estado_atual
	return "nao_encontrada"

func obter_missao(quest_id: String) -> Quest:
	return missoes.get(quest_id, null)

# ---------------- GESTÃO DE HUD / UI ----------------

func _on_missao_finalizada(quest_id: String) -> void:
	print("Missão concluída: ", quest_id)
	
	if _hud == null:
		push_error("QuestManager: O HUD é NULL! Certifique-se de chamar QuestManager.register_hud(hud) no _ready() do seu HUD ou Level principal.")
		return

	# Instancia o MissionScreen na HUD
	var quest_ui: Node = _hud.get_node_or_null(quest_id)
	if quest_ui == null:
		quest_ui = _QUEST_SCREEN.instantiate()
		quest_ui.name = quest_id
		_hud.add_child(quest_ui)

	# Chama o método de vitória diretamente na cena do card
	if quest_ui.has_method("show_completed"):
		quest_ui.show_completed()

	# Mantém na tela por 3.5s antes de remover
	await get_tree().create_timer(3.5).timeout
	_remover_hud_missao(quest_id)
	
func _remover_hud_missao(quest_id: String) -> void:
	if _hud == null: return
	var quest_ui = _hud.get_node_or_null(quest_id)
	if quest_ui:
		quest_ui.queue_free()

func _customizar_textos_finais(root_node: Node) -> void:
	var labels: Array[Node] = []
	_buscar_labels(root_node, labels)

	if labels.size() > 0:
		labels[0].text = "MISSÃO COMPLETA!"

	if labels.size() > 1:
		labels[1].text = "Parabéns pelo seu esforço!"

func _buscar_labels(node: Node, lista: Array[Node]) -> void:
	if node is Label or node is RichTextLabel:
		lista.append(node)

	for child in node.get_children():
		_buscar_labels(child, lista)
