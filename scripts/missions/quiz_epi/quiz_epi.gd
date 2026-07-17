class_name QuestQuizEpi
extends Quest

func _init() -> void:
	id = "quiz_epi"
	title = "Responda o quiz sobre os epis"
	description = "Responda corretamente qual EPI é o correto." # <-- ADICIONE ESTA LINHA AQUI!

#func progredir(dados: Dictionary = {}) -> void:
	#if estado_atual == "finalizada": return
	#
	#var quant = dados.get("amount", 1)
	#current_count = clampi(current_count + quant, 0, target_count)
	#
	#estado_atual = "em_andamento"
	#em_andamento.emit(id)
	#
	#print("Missão Riscos: ", current_count, "/", target_count)
	#
	#if current_count >= target_count:
		#finalizar()
