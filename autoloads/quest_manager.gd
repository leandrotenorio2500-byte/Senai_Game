extends Node

const _QUEST_SCREEN: PackedScene = preload("res://entities/mission_screen.tscn")
var _hud: CanvasLayer = null

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
		
	for child in _hud.get_children():
		if child.get_script() and child.get_script().get_path().ends_with("mission_screen.gd") or child.has_method("update_display"):
			child.update_display(quest_id)
			
			# Se a missão foi concluída, personaliza os textos da HUD
			if quests.has(quest_id) and quests[quest_id]["completed"]:
				_customizar_textos_finais(child)
			return

	var new_quest_screen = _QUEST_SCREEN.instantiate()
	_hud.add_child(new_quest_screen)
	new_quest_screen.update_display(quest_id)
	
	if quests.has(quest_id) and quests[quest_id]["completed"]:
		_customizar_textos_finais(new_quest_screen)

# Descobre e altera os textos de forma sequencial (Título em cima, Subtítulo embaixo)
func _customizar_textos_finais(root_node: Node) -> void:
	var lista_labels: Array[Node] = []
	_buscar_todos_labels(root_node, lista_labels)
	
	# Se achou pelo menos 1 Label, assume que é o de cima (Título)
	if lista_labels.size() > 0:
		lista_labels[0].text = "MISSÃO COMPLETA!"
		
	# Se achou um segundo Label, assume que é o de baixo (Descrição)
	if lista_labels.size() > 1:
		lista_labels[1].text = "Parabéns pelo seu esforço!"

# Função auxiliar para listar os nós de texto na ordem que aparecem na árvore
func _buscar_todos_labels(node: Node, lista: Array[Node]) -> void:
	if node is Label or node is RichTextLabel:
		lista.append(node)
	for child in node.get_children():
		_buscar_todos_labels(child, lista)

func start_quest(quest_id: String):
	if not quests.has(quest_id):
		print("Erro: Missão não encontrada: ", quest_id)
		return
		
	var quest = quests[quest_id]
	if quest["started"]:
		print("A missão [", quest_id, "] já foi iniciada anteriormente.")
		return
		
	quest["started"] = true
	print("Missão [", quest["title"], "] INICIADA!")
	quest_started.emit(quest_id) 
	
	show_quest_ui(quest_id)

func progress_quest(quest_id: String, amount: int = 1):
	if not quests.has(quest_id) or not quests[quest_id]["started"] or quests[quest_id]["completed"]:
		return
		
	var quest = quests[quest_id]
	var step_index = quest["current_step"]
	var step = quest["steps"][step_index]
	
	step["current_count"] = min(step["current_count"] + amount, step["target_count"])
	print("Progresso da Missão [", quest_id, "]: ", step["current_count"], "/", step["target_count"])
	
	if step["current_count"] >= step["target_count"]:
		advance_step(quest_id)
	else:
		show_quest_ui(quest_id)
		quest_updated.emit(quest_id, step_index)

func advance_step(quest_id: String):
	var quest = quests[quest_id]
	
	if quest["current_step"] + 1 >= quest["steps"].size():
		quest["completed"] = true
		quest_completed.emit(quest_id)
		print("Missão ", quest_id, " COMPLETADA!")
		
		show_quest_ui(quest_id)
		
		# Mantém a mensagem na tela por 2.5 segundos para o jogador ler
		await get_tree().create_timer(2.5).timeout
		
		for child in _hud.get_children():
			if child.has_method("update_display"):
				child.queue_free()
	else:
		quest["current_step"] += 1
		print("Novo objetivo liberado!")
		quest_updated.emit(quest_id, quest["current_step"])
		show_quest_ui(quest_id)
