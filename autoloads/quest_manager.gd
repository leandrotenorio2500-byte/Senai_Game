extends Node

const _QUEST_SCREEN: PackedScene = preload("res://entities/mission_screen.tscn")

var _hud: CanvasLayer = null

func register_hud(hud: CanvasLayer) -> void:
	_hud = hud

# ---------------- SINAIS ----------------
signal quest_started(quest_id)
signal quest_updated(quest_id, step_index)
signal quest_completed(quest_id)

# ---------------- MISSÕES ----------------
var quests = {
	"identificar_riscos": {
		"title": "Identificando riscos do mapa",
		"started": false,
		"current_step": 0,
		"completed": false,

		"steps": [
			{
				"description": "Converse com os responsáveis pelos setores",
				"target_count": 8,
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

# ---------------- INICIAR MISSÃO ----------------
func start_quest(quest_id: String):

	if !quests.has(quest_id):
		return

	var quest = quests[quest_id]

	if quest["started"]:
		return

	quest["started"] = true

	print("Missão iniciada: ", quest_id)

	quest_started.emit(quest_id)

	show_quest_ui(quest_id)

# ---------------- PROGREDIR MISSÃO ----------------
func progress_quest(quest_id: String, amount: int = 1):

	if !quests.has(quest_id):
		return

	var quest = quests[quest_id]

	if !quest["started"] or quest["completed"]:
		return

	var step_index = quest["current_step"]
	var step = quest["steps"][step_index]

	step["current_count"] = min(
		step["current_count"] + amount,
		step["target_count"]
	)

	print("Progresso: ", step["current_count"], "/", step["target_count"])

	if step["current_count"] >= step["target_count"]:
		advance_step(quest_id)
	else:
		quest_updated.emit(quest_id, step_index)
		show_quest_ui(quest_id)

# ---------------- AVANÇAR ETAPA ----------------
func advance_step(quest_id: String):

	var quest = quests[quest_id]

	if quest["current_step"] + 1 >= quest["steps"].size():

		quest["completed"] = true

		print("Missão concluída: ", quest_id)

		quest_completed.emit(quest_id)

		show_quest_ui(quest_id)

		await get_tree().create_timer(2.5).timeout

		_limpar_hud()

	else:

		quest["current_step"] += 1

		print("Nova etapa liberada")

		quest_updated.emit(quest_id, quest["current_step"])

		show_quest_ui(quest_id)

# ---------------- HUD ----------------
func show_quest_ui(quest_id: String):

	if _hud == null:
		return

	for child in _hud.get_children():

		if child.has_method("update_display"):

			child.update_display(quest_id)

			if quests[quest_id]["completed"]:
				_customizar_textos_finais(child)

			return

	var new_quest_screen = _QUEST_SCREEN.instantiate()

	_hud.add_child(new_quest_screen)

	new_quest_screen.update_display(quest_id)

	if quests[quest_id]["completed"]:
		_customizar_textos_finais(new_quest_screen)

func _limpar_hud():

	if _hud == null:
		return

	for child in _hud.get_children():

		if child.has_method("update_display"):
			child.queue_free()

# ---------------- TEXTO FINAL ----------------
func _customizar_textos_finais(root_node: Node):

	var labels: Array[Node] = []

	_buscar_labels(root_node, labels)

	if labels.size() > 0:
		labels[0].text = "MISSÃO COMPLETA!"

	if labels.size() > 1:
		labels[1].text = "Parabéns pelo seu esforço!"

func _buscar_labels(node: Node, lista: Array[Node]):

	if node is Label or node is RichTextLabel:
		lista.append(node)

	for child in node.get_children():
		_buscar_labels(child, lista)
