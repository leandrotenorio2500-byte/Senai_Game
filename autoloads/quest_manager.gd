extends Node

# Sinais para avisar a UI ou o mundo que algo mudou
signal quest_updated(quest_id, step_index)
signal quest_completed(quest_id)

# Estrutura de dados das missões
var quests = {
	"aprendiz_senai": {
		"title": "O Jovem Aprendiz",
		"current_step": 0,
		"steps": [
			{
				"description": "Encontre os pontos de risco no mapa",
				"target_count": 3,
				"current_count": 0
			},
			{
				"description": "Fale com 2 pessoas sobre o atendimento do SENAI",
				"target_count": 2,
				"current_count": 0
			}
		],
		"completed": false
	}
}

# Função para avançar o progresso de um objetivo
func progress_quest(quest_id: String, amount: int = 1):
	if not quests.has(quest_id) or quests[quest_id]["completed"]:
		return
		
	var quest = quests[quest_id]
	var step_index = quest["current_step"]
	var step = quest["steps"][step_index]
	
	# Incrementa o progresso do passo atual
	step["current_count"] += amount
	print("Progresso da Missão [", quest_id, "]: ", step["current_count"], "/", step["target_count"])
	
	# Verifica se o passo atual foi concluído
	if step["current_count"] >= step["target_count"]:
		advance_step(quest_id)
	else:
		quest_updated.emit(quest_id, step_index)

# Função interna para passar para o próximo objetivo ou concluir a missão
func advance_step(quest_id: String):
	var quest = quests[quest_id]
	quest["current_step"] += 1
	
	# Se passou do último passo, a missão acabou
	if quest["current_step"] >= quest["steps"].size():
		quest["completed"] = true
		quest_completed.emit(quest_id)
		print("Missão ", quest_id, " COMPLETADA!")
	else:
		print("Novo objetivo liberado!")
		quest_updated.emit(quest_id, quest["current_step"])
