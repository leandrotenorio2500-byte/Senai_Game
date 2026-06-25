extends Node

signal quest_started(quest_id) # Novo sinal para avisar a UI que a missão começou
signal quest_updated(quest_id, step_index)
signal quest_completed(quest_id)

var quests = {
	"identificar_riscos": {
		"title": "Identificando riscos do mapa",
		"started": false,       # <-- NOVA PROPRIEDADE: Controla se o jogador já aceitou a missão
		"current_step": 0,
		"steps": [
			{
				"description": "Encontre os pontos de risco no mapa",
				"target_count": 3,
				"current_count": 0
			},
		],
		"completed": false
	},
}

# --- O GATILHO PARA INICIAR A MISSÃO ---
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
	quest_started.emit(quest_id) # Dispara o sinal (ótimo para mostrar na tela "Nova Missão!")

# Modifique o início da sua função original para ignorar se a missão não começou
func progress_quest(quest_id: String, amount: int = 1):
	# Agora checa se ela NÃO começou OU se já terminou
	if not quests.has(quest_id) or not quests[quest_id]["started"] or quests[quest_id]["completed"]:
		return
		
	var quest = quests[quest_id]
	var step_index = quest["current_step"]
	var step = quest["steps"][step_index]
	
	step["current_count"] += amount
	print("Progresso da Missão [", quest_id, "]: ", step["current_count"], "/", step["target_count"])
	
	if step["current_count"] >= step["target_count"]:
		advance_step(quest_id)
	else:
		quest_updated.emit(quest_id, step_index)

func advance_step(quest_id: String):
	var quest = quests[quest_id]
	quest["current_step"] += 1
	
	if quest["current_step"] >= quest["steps"].size():
		quest["completed"] = true
		quest_completed.emit(quest_id)
		print("Missão ", quest_id, " COMPLETADA!")
	else:
		print("Novo objetivo liberado!")
		quest_updated.emit(quest_id, quest["current_step"])
